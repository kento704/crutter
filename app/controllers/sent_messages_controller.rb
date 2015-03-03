# coding: utf-8

class SentMessagesController < ApplicationController

  def index
    @sent_messages = SentMessage.all.includes([:account, :direct_message])
  end

end
