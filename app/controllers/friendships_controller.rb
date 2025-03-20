class FriendshipsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_friendship, only: [ :update, :destroy ]

  def create
    @friend = User.find(params[:friend_id])
    if current_user.send_friend_request(@friend)
      redirect_to @friend, notice: "Demande d'amiti\u00E9 envoy\u00E9e avec succ\u00E8s."
    else
      redirect_to @friend, alert: "Impossible d'envoyer la demande d'amiti\u00E9."
    end
  end

  def update
    if @friendship.friend == current_user
      if params[:status] == "accepted"
        @friendship.accept!
        redirect_to current_user, notice: "Demande d'amiti\u00E9 accept\u00E9e."
      elsif params[:status] == "rejected"
        @friendship.reject!
        redirect_to current_user, notice: "Demande d'amiti\u00E9 refus\u00E9e."
      end
    else
      redirect_to root_path, alert: "Action non autoris\u00E9e."
    end
  end

  def destroy
    if @friendship.user == current_user || @friendship.friend == current_user
      @friendship.destroy
      redirect_to current_user, notice: "Amiti\u00E9 supprim\u00E9e."
    else
      redirect_to root_path, alert: "Action non autoris\u00E9e."
    end
  end

  private

  def set_friendship
    @friendship = Friendship.find(params[:id])
  end
end
