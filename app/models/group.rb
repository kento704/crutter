# == Schema Information
#
# Table name: groups
#
#  id                 :integer          not null, primary key
#  name               :string(255)
#  display_order      :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  message_pattern_id :integer
#

class Group < ActiveRecord::Base

  has_many :accounts
  belongs_to :message_pattern

  delegate :title, to: :message_pattern, prefix: true, allow_nil: true

  before_validation :set_display_order, unless: -> model { model.persisted? }

  scope :before, -> order {
    where(Group.arel_table[:display_order].lt(order))
  }

  scope :after, -> order {
    where(Group.arel_table[:display_order].gt(order))
  }

  def self.update_order(smaller, larger, diff)
    Group.after(smaller).before(larger).update_all("display_order = display_order + #{diff}")
  end

  def set_display_order
    self.display_order = Group.all.count
  end

end
