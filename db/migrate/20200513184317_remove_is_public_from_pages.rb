class RemoveIsPublicFromPages < ActiveRecord::Migration[6.0]
  def change
    remove_column :pages, :is_public, :boolean, null: false, default: false
  end
end
