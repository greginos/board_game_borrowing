class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [ :show, :edit, :update ]

  def show
    if params[:id] == "me" || params[:id].nil?
      @user = current_user
    else
      @user = User.find(params[:id])
    end
    @board_games = @user.board_games.page(params[:page]).per(10)
  end

  def edit
    unless current_user == @user
      redirect_to @user, alert: "Vous n'êtes pas autorisé à modifier ce profil."
    end
  end

  def update
    if @user.update(user_params)
      redirect_to @user, notice: "Profil mis à jour avec succès."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def update_favorites
    user = current_user
    favorite_id = favorite_params[:favorite_id].to_i
    if user.favorites.include?(favorite_id)
      user.favorites.delete(favorite_id)
      text = "Jeu retiré de vos favoris."
    else
      user.favorites << favorite_id
      text = "Jeu ajouté à vos favoris."
    end
    if user.save
      respond_to do |format|
        format.html { redirect_back fallback_location: board_game_path(favorite_id), notice: text }
      end
    else
      respond_to do |format|
        format.html { redirect_back fallback_location: board_game_path(favorite_id), alert: "Erreur lors de la mise à jour." }
      end
    end
  end

  def index
    @users = User.all
    if params[:pseudo].present?
      @users = @users.where("unaccent(pseudo) ILIKE unaccent(?)", "%#{params[:pseudo]}%")
    end
    if params[:email].present?
      @users = @users.where("email ILIKE ?", "%#{params[:email]}%")
    end
    @users = @users.first(10)

    respond_to do |format|
      format.html
      format.json { render json: @users }
    end
  end

  def search_form
  end

  private

  def set_user
    if params[:user_id].present?
      @user = User.find(params[:user_id])
    elsif params[:id] == "me" && current_user
        @user = current_user
    elsif params[:id]
        @user = User.find(params[:id])
    else
      @user = current_user
    end
  end

  def user_params
    params.require(:user).permit(:pseudo, :description, :avatar)
  end

  def favorite_params
    params.permit(:favorite_id)
  end
end
