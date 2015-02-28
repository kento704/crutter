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

require 'rails_helper'

RSpec.describe SentMessage, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
