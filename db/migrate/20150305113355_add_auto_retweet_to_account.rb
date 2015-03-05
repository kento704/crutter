class AddAutoRetweetToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :auto_retweet, :boolean, default: true
  end
end
