class FollowerHistoriesController < ApplicationController

  # GET /follower_histories
  def index
    @followers_count_data = {}
    FollowerHistory.where(FollowerHistory.arel_table[:created_at].gt(7.days.ago)).group(:created_at).sum(:followers_count).each do |k, v|
      @followers_count_data[k] = v
    end
  end
end