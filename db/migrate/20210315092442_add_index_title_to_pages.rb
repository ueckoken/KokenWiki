class AddIndexTitleToPages < ActiveRecord::Migration[6.0]
  def change
    add_index :pages, :title
  end
end
