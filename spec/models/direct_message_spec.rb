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

require 'rails_helper'

RSpec.describe DirectMessage, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
