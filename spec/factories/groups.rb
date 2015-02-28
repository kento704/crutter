# == Schema Information
#
# Table name: groups
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  display_order :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

FactoryGirl.define do
  factory :group do
    name "MyString"
  end

end
