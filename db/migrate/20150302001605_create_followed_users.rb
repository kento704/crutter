class CreateFollowedUsers < ActiveRecord::Migration
  def change
    create_table :followed_users do |t|
      t.references :target, index: true
      t.references :account, index: true
      t.integer :user_id, limit: 8

      t.timestamps null: false
    end
    add_foreign_key :followed_users, :targets
    add_foreign_key :followed_users, :accounts
  end
end
