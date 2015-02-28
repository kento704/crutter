class CreateDirectMessages < ActiveRecord::Migration
  def change
    create_table :direct_messages do |t|
      t.references :message_pattern, index: true
      t.string :text
      t.integer :step

      t.timestamps null: false
    end
    add_foreign_key :direct_messages, :message_patterns
  end
end
