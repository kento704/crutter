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

require 'rails_helper'

RSpec.describe FollowerHistory, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
