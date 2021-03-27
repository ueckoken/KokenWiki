class FixMismatchSchema < ActiveRecord::Migration[6.0]
  def up
    change_column :pages, :content, :text, size: :long, null: false
    change_column :update_histories, :content, :text, size: :long, null: false
  end
  def down
    change_column :pages, :content, :text, null: false
    change_column :update_histories, :content, :string, null: false
  end
end
