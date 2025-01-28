class GamesController < ApplicationController
  def index
    user = User.find(params[:user_id])

    @games = user.games
    respond_to do |format|
      format.html
      format.json { render json: @games }
    end
  end
end
