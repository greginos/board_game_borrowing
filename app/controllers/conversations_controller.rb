class ConversationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @conversations = Conversation
      .where("user1_id = ? OR user2_id = ?", current_user.id, current_user.id)
      .includes(:messages)
      .order("messages.created_at DESC")
      .group_by { |c| c.user1 == current_user ? c.user2 : c.user1 }

    @contacts = current_user.all_friends
  end

  def show
    @conversation = Conversation.find(params[:id])
  end

  def create
    @conversation = Conversation.find_or_create_by(user1: current_user, user2_id: params[:user_id])
    redirect_to @conversation
  end
end
