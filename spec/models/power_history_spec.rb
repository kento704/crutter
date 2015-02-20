# == Schema Information
#
# Table name: power_histories
#
#  id            :integer          not null, primary key
#  followers_sum :integer          not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'rails_helper'

RSpec.describe PowerHistory, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
