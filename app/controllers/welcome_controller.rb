class WelcomeController < ApplicationController
  def index
    @groups = Group.order(:display_order).includes([{accounts: :target}, :message_pattern])
  end
end