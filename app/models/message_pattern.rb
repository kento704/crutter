# == Schema Information
#
# Table name: message_patterns
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class MessagePattern < ActiveRecord::Base
  has_many :direct_messages
  has_many :groups
end
