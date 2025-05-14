require "commonmarker"

class Page < ApplicationRecord
  include MarkdownHelper
  include UriHelper
  include PathHelper

  belongs_to :user
  belongs_to :editable_group, class_name: "Usergroup", optional: true
  belongs_to :readable_group, class_name: "Usergroup", optional: true

  has_many :children, class_name: "Page",
                        foreign_key: "parent_id"

  belongs_to :parent, class_name: "Page", optional: true

  has_many :update_histories
  has_many :comments

  has_many_attached :files

  validates :title, uniqueness: { scope: :parent_id }
  validates :title, exclusion: { in: [nil] }, format: { with: /\A[^?.]*\z/ }
  validates :title, inclusion: { in: [""], message: "of root page must be empty string" }, if: -> { parent.nil? }
  validates :title, exclusion: { in: [""], message: "cannot be empty string" }, if: -> { ! parent.nil? }
  validates :content, presence: true

  attribute :content, default: "new page"

  after_update :notify_webhook, if: :saved_change_to_content?

  scope :search, ->(column, query) { where("MATCH (#{Page.connection.quote_column_name(column)}) AGAINST (? IN BOOLEAN MODE)", query) if query.present? }
  scope :stricter_slow_search, ->(column, query) { where("#{Page.connection.quote_column_name(column)} LIKE ?", "%#{query}%") if query.present? }

  def self.find_by_pathname(pathname)
    if pathname.root?
      return Page.where(title: "", parent: nil).take
    end
    sql = <<~SQL.squish
    WITH RECURSIVE ancestors(id, source_id, parent_id, level, title) AS (
        SELECT id, id AS source_id, parent_id, 0 AS level, title FROM #{Page.table_name} WHERE title = :title
        UNION ALL
        SELECT page.id, ancestors.source_id AS source_id, page.parent_id, ancestors.level + 1 AS level, page.title FROM #{Page.table_name} AS page, ancestors WHERE ancestors.parent_id = page.id
    ),
    pages_with_path(id, path) AS (
        SELECT source_id AS id, GROUP_CONCAT(title ORDER BY level DESC SEPARATOR "/") AS path FROM ancestors GROUP BY source_id HAVING path = :path
    )
    SELECT * FROM #{Page.table_name} WHERE id = (SELECT id FROM pages_with_path LIMIT 1) LIMIT 1;
    SQL
    page = Page.find_by_sql([sql, { title: pathname.basename.to_s, path: pathname.to_s }])
    # page must be single
    return page[0]
  end

  def self.get_paths_by_ids(ids)
    if ids.empty?
      return []
    end
    sql = <<~SQL.squish
    WITH RECURSIVE ancestors(id, source_id, parent_id, level, title) AS (
        SELECT id, id AS source_id, parent_id, 0 AS level, title FROM #{Page.table_name} WHERE id IN (:ids)
        UNION ALL
        SELECT page.id, ancestors.source_id AS source_id, page.parent_id, ancestors.level + 1 AS level, page.title FROM #{Page.table_name} AS page, ancestors WHERE ancestors.parent_id = page.id
    )
    SELECT source_id AS id, GROUP_CONCAT(title ORDER BY level DESC SEPARATOR "/") AS path FROM ancestors GROUP BY source_id
    SQL
    sql = ActiveRecord::Base.sanitize_sql_array([sql, { ids: ids }])
    pages = ActiveRecord::Base.connection.select_all(sql)
    return pages
  end

  def root?
    parent.nil? && title == ""
  end

  def self_and_ancestors
    sql = <<~SQL.squish
      WITH RECURSIVE ancestors(id, source_id, parent_id, level, title) AS (
          SELECT id, id AS source_id, parent_id, 0 AS level, title FROM #{Page.table_name} WHERE id = :id
          UNION ALL
          SELECT page.id, ancestors.source_id AS source_id, page.parent_id, ancestors.level + 1 AS level, page.title FROM #{Page.table_name} AS page, ancestors WHERE ancestors.parent_id = page.id
      )
      SELECT page.* FROM #{Page.table_name} AS page, ancestors WHERE page.id = ancestors.id ORDER BY ancestors.level;
    SQL
    self_and_ancestors = Page.find_by_sql([sql, { id: self.id }])
    return self_and_ancestors
  end

  def self_and_descendants
    sql = <<~SQL.squish
      WITH RECURSIVE descendants(id, source_id, parent_id, level, title) AS (
          SELECT id, id AS source_id, parent_id, 0 AS level, title FROM #{Page.table_name} WHERE id = :id
          UNION ALL
          SELECT page.id, descendants.source_id AS source_id, page.parent_id, descendants.level + 1 AS level, page.title FROM #{Page.table_name} AS page, descendants WHERE descendants.id = page.parent_id
      )
      SELECT page.* FROM #{Page.table_name} AS page, descendants WHERE page.id = descendants.id ORDER BY descendants.level;
    SQL
    descendants = Page.find_by_sql([sql, { id: self.id }])
    return descendants
  end

  def path
    if self.root?
      return "/"
    end
    ancestors_titles = self.self_and_ancestors.map(&:title)
    # 最後の要素は必ず root (＝titleが空文字列 "") のため除外
    ancestors_titles.pop
    path = ancestors_titles.reverse.join("/")
    return "/" + path
  end

  def pathname
    return Pathname.new(path)
  end

  def link_paths
    anchor_nodes = []
    doc_of_content.walk do |node|
      if (node.type != :link) || is_external_uri?(node.url) || !is_path?(node.url)
        next
      end
      # wiki internal link only here
      anchor_nodes << node
    end
    paths = anchor_nodes.map do |node|
      pathname = Pathname.new(node.url.force_encoding("UTF-8")).cleanpath
      if !pathname.absolute?
        base_path = self.root? ? self.path : self.path + "/"
        pathname = pathname.expand_path(base_path)
      end
      pathname
    end
    return paths.uniq
  end

  def links
    link_pages = link_paths
      .map { |path| Page.find_by_pathname(path) }
      .compact
    link_page_ids = link_pages.pluck(:id)
    return Page.where(id: link_page_ids)
  end

  def backlinks
    # Markdownのリンク記法 [text](path/to/title) の title) を手掛かりに検索
    # パス末尾のスラッシュ / ありなしどちらも対応
    if root?
      path_included_pages = Page.stricter_slow_search(:content, "](/)")
        .or(Page.stricter_slow_search(:content, "..)"))
        .or(Page.stricter_slow_search(:content, "../)"))
    else
      path_included_pages = Page.stricter_slow_search(:content, title + ")")
        .or(Page.stricter_slow_search(:content, title + "/)"))
    end
    backlink_pages = path_included_pages.filter { |page| page.link_paths.include?(pathname) }
    backlink_page_ids = backlink_pages.pluck(:id)
    return Page.where(id: backlink_page_ids)
  end

  def plain_text_content
    return render_plain_text(doc_of_content)
  end

  private
    def doc_of_content
      @doc ||= CommonMarker.render_doc(self.content, :DEFAULT, [:table])
      return @doc
    end
    
    def notify_webhook
      WebhookJob.perform_later(id, user_id)
    end
end
