class AddIndexToPage < ActiveRecord::Migration[6.0]
  def change
    add_index :pages, [:updated_at, :path]
    add_index :update_histories, :created_at
  end
end
