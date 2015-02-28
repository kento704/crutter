class MessagePatternsController < ApplicationController
  permits :title

  def new
    @message_pattern = MessagePattern.new
  end

  def edit(id)
    @message_pattern = MessagePattern.find(id)
  end

  def create(message_pattern)
    @message_pattern = MessagePattern.new(message_pattern)

    if @message_pattern.save
      redirect_to direct_messages_path
    else
      render :new
    end
  end

  def update(id, message_pattern)
    @message_pattern = MessagePattern.find(id)
    if @message_pattern.update(message_pattern)
      redirect_to direct_messages_path
    else
      render :edit
    end
  end

end