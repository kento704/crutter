class WelcomeController < ApplicationController
  def index
    @groups = Group.order(:display_order)
  end
end