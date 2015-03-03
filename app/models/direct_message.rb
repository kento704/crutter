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

class DirectMessage < ActiveRecord::Base
  belongs_to :message_pattern
  has_many :sent_messages
end
