# coding: utf-8

class SentMessagesController < ApplicationController

  def index
    @message_patterns = MessagePattern.includes(direct_messages:[sent_messages: :account])
  end

end
