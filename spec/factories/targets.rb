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

FactoryGirl.define do
  factory :target do
    name "MyString"
screen_name "MyString"
  end

end
