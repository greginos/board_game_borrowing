class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_conversation, only: [ :create ]

  def create
    @message = @conversation.messages.build(message_params)
    @message.from = current_user
    @message.to = @conversation.other_user(current_user)

    if @message.save
      redirect_to @conversation, notice: "Message envoyé."
    else
      redirect_to @conversation, alert: "Erreur lors de l'envoi du message."
    end
  end

  private

  def set_conversation
    @conversation = Conversation.find(params[:conversation_id])
  end

  def message_params
    params.require(:message).permit(:text)
  end
end
