class HasManyThroughToHasAndBelongsToMany < ActiveRecord::Migration[6.0]
  def up
    remove_column :user_usergroups, :id, :bitint
    remove_column :user_usergroups, :created_at, :datetime, null: false
    remove_column :user_usergroups, :updated_at, :datetime, null: false
    rename_table :user_usergroups, :usergroups_users
  end
  def down
    rename_table :usergroups_users, :user_usergroups
    add_column :user_usergroups, :id, :primary_key
    add_column :user_usergroups, :created_at, :datetime, null: true
    add_column :user_usergroups, :updated_at, :datetime, null: true
    Usergroup.update_all(
      created_at: Time.current,
      updated_at: Time.current
    )
    change_column :user_usergroups, :created_at, :datetime, null: false
    change_column :user_usergroups, :updated_at, :datetime, null: false
  end
end
