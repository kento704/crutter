# == Schema Information
#
# Table name: sent_messages
#
#  id                :integer          not null, primary key
#  account_id        :integer
#  direct_message_id :integer
#  to_user_id        :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

FactoryGirl.define do
  factory :sent_message do
    account nil
direct_message nil
  end

end
