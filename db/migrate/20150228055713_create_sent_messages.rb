class CreateSentMessages < ActiveRecord::Migration
  def change
    create_table :sent_messages do |t|
      t.references :account, index: true
      t.references :direct_message, index: true
      t.integer :to_user_id

      t.timestamps null: false

      t.index :to_user_id
    end
    add_foreign_key :sent_messages, :accounts
    add_foreign_key :sent_messages, :direct_messages
  end
end
