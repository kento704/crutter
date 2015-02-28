class CreateFollowerHistories < ActiveRecord::Migration
  def change
    create_table :follower_histories do |t|
      t.references :account, index: true
      t.string :followers_count

      t.timestamps null: false
    end
    add_foreign_key :follower_histories, :accounts
  end
end
