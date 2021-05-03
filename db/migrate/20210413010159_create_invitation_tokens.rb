class CreateInvitationTokens < ActiveRecord::Migration[6.0]
  def change
    create_table :invitation_tokens do |t|
      t.string :token, null: false
      t.datetime :expired_at
      t.references :created_by, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
