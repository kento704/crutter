class AddNameAndScreenNameToFollowedUsers < ActiveRecord::Migration
  def change
    add_column :followed_users, :name, :string
    add_column :followed_users, :screen_name, :string
  end
end
