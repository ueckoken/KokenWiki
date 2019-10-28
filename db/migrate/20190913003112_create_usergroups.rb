class CreateUsergroups < ActiveRecord::Migration[5.2]
  def change
    create_table :usergroups do |t|
      
      t.references :create_user
      t.string :name
      t.timestamps
    end
  end
end
