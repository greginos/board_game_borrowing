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
    # Marquer les messages non lus comme lus
    @conversation.messages
                .where.not(from: current_user)
                .where(read: false)
                .update_all(read: true)
  end

  def create
    @other_user = User.find(params[:user_id])

    # Vérifier si une conversation existe déjà
    @conversation = Conversation.where(
      "(user1_id = ? AND user2_id = ?) OR (user1_id = ? AND user2_id = ?)",
      current_user.id, @other_user.id,
      @other_user.id, current_user.id
    ).first

    # Créer une nouvelle conversation si elle n'existe pas
    @conversation ||= Conversation.create!(
      user1: current_user,
      user2: @other_user
    )

    redirect_to @conversation
  rescue ActiveRecord::RecordNotFound
    redirect_to conversations_path, alert: "Utilisateur non trouvé."
  rescue => e
    Rails.logger.error "Erreur lors de la création de la conversation: #{e.message}"
    redirect_to conversations_path, alert: "Une erreur est survenue lors de la création de la conversation."
  end
end
