class UsersController < ApplicationController
  def show
    if params[:id] == "me" && current_user
      @user = current_user
    else
      @user = User.find(params[:id])
    end

    raise ActiveRecord::RecordNotFound unless @user
  end
  def index
    user = User.find(params[:user_id])

    @games = user.games
    respond_to do |format|
      format.html
      format.json { render json: @games }
    end
  end
end
