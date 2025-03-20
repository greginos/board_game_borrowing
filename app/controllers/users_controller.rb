class UsersController < ApplicationController
  before_action :authenticate_user!, except: [ :show ]
  before_action :set_user, only: [ :show, :edit, :update ]

  def show
    raise ActiveRecord::RecordNotFound unless @user
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

  def index
    user = User.find(params[:user_id])

    @games = user.games
    respond_to do |format|
      format.html
      format.json { render json: @games }
    end
  end

  private

  def set_user
    if params[:id] == "me" && current_user
      @user = current_user
    else
      @user = User.find(params[:id])
    end
  end

  def user_params
    params.require(:user).permit(:pseudo, :description, :avatar)
  end
end
