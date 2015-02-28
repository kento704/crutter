class CreateMessagePatterns < ActiveRecord::Migration
  def change
    create_table :message_patterns do |t|
      t.string :title

      t.timestamps null: false
    end
  end
end
