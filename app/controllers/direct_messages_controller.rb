class DirectMessagesController < ApplicationController
  permits :message_pattern_id, :step, :text

  def index
    @message_patterns = MessagePattern.includes(:direct_messages)
  end

  def new(message_pattern_id)
    @direct_message = DirectMessage.new(message_pattern_id: message_pattern_id.to_i)
  end

  def edit(id)
    @direct_message = DirectMessage.find(id)
  end

  def create(direct_message)
    @direct_message = DirectMessage.new(direct_message)

    if @direct_message.save
      redirect_to direct_messages_path
    else
      render :new
    end
  end

  def update(id, direct_message)
    @direct_message = DirectMessage.find(id)

    if @direct_message.update(direct_message)
      redirect_to direct_messages_path
    else
      render :edit
    end
  end
end