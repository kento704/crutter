class AddMessagePatternToGroup < ActiveRecord::Migration
  def change
    add_reference :groups, :message_pattern, index: true
    add_foreign_key :groups, :message_patterns
  end
end
