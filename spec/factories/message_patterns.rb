# == Schema Information
#
# Table name: message_patterns
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :message_pattern do
    title "MyString"
  end

end
