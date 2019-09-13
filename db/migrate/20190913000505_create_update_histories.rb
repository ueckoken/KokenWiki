class CreateUpdateHistories < ActiveRecord::Migration[5.2]
  def change
    create_table :update_histories do |t|
      t.belongs_to :page
      t.belongs_to :user
      
      t.string :content

      t.timestamps
    end
  end
end
