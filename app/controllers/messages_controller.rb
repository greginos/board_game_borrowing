class MessagesController < ApplicationController
  before_action :authenticate_user!

  def index
    @conversations = Message.where(from: current_user)
                          .or(Message.where(to: current_user))
                          .order(created_at: :desc)
                          .group_by { |m| [ m.from, m.to ].find { |u| u != current_user } }
  end

  def show
    @other_user = User.find(params[:id])
    @messages = Message.where(from: [ current_user, @other_user ], to: [ current_user, @other_user ])
                      .order(created_at: :asc)
  end

  def create
    @message = current_user.sent_messages.build(message_params)
    @message.to = User.find(message_params[:to_id])
    @message.friendship = current_user.friendship_with(@message.to)
    if @message.save
      redirect_to conversation_messages_path(id: @message.to.id), notice: "Message envoy\u00E9."
    else
      redirect_to conversation_messages_path(id: @message.to.id), alert: "Erreur lors de l'envoi du message."
    end
  end

  private

  def message_params
    params.require(:message).permit(:text, :to_id)
  end
end
