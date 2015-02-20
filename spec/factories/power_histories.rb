# == Schema Information
#
# Table name: power_histories
#
#  id            :integer          not null, primary key
#  followers_sum :integer          not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

FactoryGirl.define do
  factory :power_history do
    followers_sum 1
  end

end
