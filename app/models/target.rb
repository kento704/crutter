# == Schema Information
#
# Table name: targets
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  screen_name :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Target < ActiveRecord::Base
  has_one :account
  has_many :followed_users
end
