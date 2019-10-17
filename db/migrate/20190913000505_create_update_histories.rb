class CreateUpdateHistories < ActiveRecord::Migration[5.2]
  def change
    create_table :update_histories do |t|
      t.belongs_to :page
      t.belongs_to :user
      
      t.string :content, null: false

      t.timestamps
    end
  end
end
