# == Schema Information
#
# Table name: followed_users
#
#  id         :integer          not null, primary key
#  target_id  :integer
#  account_id :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class FollowedUser < ActiveRecord::Base
  belongs_to :target
  belongs_to :account
end
