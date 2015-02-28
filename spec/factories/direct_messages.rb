# == Schema Information
#
# Table name: direct_messages
#
#  id                 :integer          not null, primary key
#  message_pattern_id :integer
#  text               :string(255)
#  step               :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

FactoryGirl.define do
  factory :direct_message do
    message_pattern nil
text "MyString"
step 1
  end

end
