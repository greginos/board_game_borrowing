class BoardGamesController < ApplicationController
  before_action :set_board_game, only: [ :show, :edit, :update, :destroy ]

  def index
    @board_games = BoardGame.all
    respond_to do |format|
      format.html # Standard HTML response
      format.turbo_stream # Turbo Stream response for dynamic updates
    end
  end

  def show
  end

  def new
    @board_game = BoardGame.new
  end

  def create
    board_game = BarcodeConverter.new(board_game_params[:ean]).convert

    if board_game.present?
      redirect_to board_games_path, notice: "BoardGame was successfully created."
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @board_game.update(board_game_params)
      redirect_to board_games_path, notice: "BoardGame was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @board_game.destroy
    redirect_to board_games_path, notice: "BoardGame was successfully destroyed."
  end

  private

  def set_board_game
    @board_game = BoardGame.find(params[:id])
  end

  def board_game_params
    params.require(:board_game).permit(:name, :ean)
  end
end
