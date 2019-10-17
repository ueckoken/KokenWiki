class CreateUserUsergroups < ActiveRecord::Migration[5.2]
  def change
    create_table :user_usergroups do |t|
      t.references :user 
      t.references :usergroup

      t.timestamps
    end
  end
end
