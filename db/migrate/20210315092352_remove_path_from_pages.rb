class RemovePathFromPages < ActiveRecord::Migration[6.0]
  def change
    remove_column :pages, :path, :string
  end
end
