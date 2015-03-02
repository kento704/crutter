class AddTargetToAccounts < ActiveRecord::Migration
  def change
    remove_column :accounts, :target_user
    add_reference :accounts, :target, index: true
    add_foreign_key :accounts, :targets
  end
end
