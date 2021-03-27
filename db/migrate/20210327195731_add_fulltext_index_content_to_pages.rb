class AddFulltextIndexContentToPages < ActiveRecord::Migration[6.0]
  def up
    execute <<~SQL.squish
      CREATE FULLTEXT INDEX index_pages_on_content ON pages (content) WITH PARSER ngram;
    SQL
  end
  def down
    remove_index :pages, name: :index_pages_on_content
  end
end
