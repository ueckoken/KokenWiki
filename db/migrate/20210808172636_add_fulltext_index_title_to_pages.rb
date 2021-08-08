class AddFulltextIndexTitleToPages < ActiveRecord::Migration[6.1]
  def up
    execute <<~SQL.squish
      CREATE FULLTEXT INDEX fulltext_index_pages_on_title ON pages (title) WITH PARSER ngram;
    SQL
  end
  def down
    remove_index :pages, name: :index_pages_on_content
  end
end
