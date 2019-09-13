class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|

      t.belongs_to :user
      t.belongs_to :page
      t.text :comment
      t.timestamps
    end
  end
end
