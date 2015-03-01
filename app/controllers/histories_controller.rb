class HistoriesController < ApplicationController

  # GET /histories
  def index
    begin
      lg = IO.readlines("log/cron_standard.log")
      @standard_histories = lg
      @standard_histories = lg[-100..-1] if lg.length > 100
    rescue => e
      @standard_histories = []
    end

    begin
      lg = IO.readlines("log/cron_error.log")
      @error_histories = lg
      @error_histories = lg[-100..-1] if lg.length > 100
    rescue => e
      @error_histories = []
    end
    
    @followers_count_data = {}
    FollowerHistory.where(FollowerHistory.arel_table[:created_at].gt(7.days.ago)).group(:created_at).sum(:followers_count).each do |k, v|
      @followers_count_data[k] = v
    end
  end
end