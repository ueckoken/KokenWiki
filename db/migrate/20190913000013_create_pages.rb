class CreatePages < ActiveRecord::Migration[5.2]
  def change
    create_table :pages do |t|

      
      t.references :readable_group
      t.references :editable_group
      t.references :parent
      t.references :user

      #t.string :parent
      t.string :title, null: false
      t.text :content, null: false
      t.string :path, null: false

      t.boolean :is_draft, default: false, null: false
      t.boolean :is_public, default: false, null: false

      t.timestamps
    end
  end
end
