class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.references :group, null: false, index: true
      t.string :screen_name, null: false
      t.string :target_user, default: ""
      t.string :oauth_token, null: false
      t.string :oauth_token_secret, null: false
      t.integer :friends_count, default: 0
      t.integer :followers_count, default: 0
      t.string :description, default: ""
      t.boolean :auto_update, default: true
      t.boolean :auto_follow, default: true
      t.boolean :auto_unfollow, default: true

      t.timestamps null: false

      t.index :screen_name
    end
  end
end
