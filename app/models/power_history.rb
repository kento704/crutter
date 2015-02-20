# == Schema Information
#
# Table name: power_histories
#
#  id            :integer          not null, primary key
#  followers_sum :integer          not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class PowerHistory < ActiveRecord::Base
end
