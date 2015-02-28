# == Schema Information
#
# Table name: follower_histories
#
#  id              :integer          not null, primary key
#  account_id      :integer
#  followers_count :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class FollowerHistory < ActiveRecord::Base
  belongs_to :account
end
