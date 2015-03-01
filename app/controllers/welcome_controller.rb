class WelcomeController < ApplicationController
  def index
    @groups = Group.order(:display_order).includes(:accounts, :message_pattern)
  end
end