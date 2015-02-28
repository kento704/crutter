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

FactoryGirl.define do
  factory :follower_history do
    account nil
followers_count "MyString"
  end

end
