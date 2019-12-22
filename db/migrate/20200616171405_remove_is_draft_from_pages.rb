class RemoveIsDraftFromPages < ActiveRecord::Migration[6.0]
  def change
    remove_column :pages, :is_draft, :boolean
  end
end
