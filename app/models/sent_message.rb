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

class SentMessage < ActiveRecord::Base
  belongs_to :account
  belongs_to :direct_message
end
