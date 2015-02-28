class AddAutoDirectMessageToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :auto_direct_message, :boolean, default: true
  end
end
