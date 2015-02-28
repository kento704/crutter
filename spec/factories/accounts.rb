# == Schema Information
#
# Table name: accounts
#
#  id                  :integer          not null, primary key
#  group_id            :integer          not null
#  screen_name         :string(255)      not null
#  target_user         :string(255)      default("")
#  oauth_token         :string(255)      not null
#  oauth_token_secret  :string(255)      not null
#  friends_count       :integer          default("0")
#  followers_count     :integer          default("0")
#  description         :string(255)      default("")
#  auto_update         :boolean          default("1")
#  auto_follow         :boolean          default("1")
#  auto_unfollow       :boolean          default("1")
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  auto_direct_message :boolean          default("1")
#

FactoryGirl.define do
  factory :account do
    screen_name "MyString"
oauth_token "MyString"
oauth_token_secret "MyString"
uid "MyString"
  end

end
