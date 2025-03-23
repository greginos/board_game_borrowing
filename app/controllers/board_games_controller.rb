class BoardGamesController < ApplicationController
  before_action :set_board_game, only: [ :show, :edit, :update, :destroy ]

  def index
    @board_games = BoardGame.all

    if search_params["players"].present?
      players = search_params["players"].to_i
      @board_games = @board_games.where("min_players <= ? AND max_players >= ?", players, players)
    end

    if search_params["age_min"].present?
      @board_games = @board_games.where("minimum_age >= ? OR minimum_age IS NULL", params["age_min"].to_i)
    end

    if search_params["query"].present?
      @board_games = @board_games.where("name ILIKE ?", "%#{params[:query]}%")
    end
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

  def scan
    @board_game = BoardGame.new

    if params[:ean].present?
      game_data = BarcodeConverter.new(params[:ean]).convert

      if game_data
        @board_game.name = game_data[:name]
        @board_game.image_link = game_data[:image_link]
        @board_game.ean = params[:ean]
        @board_game.min_players = game_data[:min_players]
        @board_game.max_players = game_data[:max_players]
        @board_game.minimum_age = game_data[:minimum_age]
        @board_game.length = game_data[:length]
      else
        flash[:alert] = "Aucune information trouvée pour cet EAN."
      end
    end
  end

  def create
    @board_game = BoardGame.new(board_game_params)

    if @board_game.save
      redirect_to @board_game, notice: "Le jeu a été enregistré avec succès !"
    else
      render :scan
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

  def search_params
    params.permit(:players, :age_min, :query, :commit)
  end

  def board_game_params
    params.require(:board_game).permit(:name, :ean, :image_link, :min_players, :max_players, :minimum_age, :length)
  end
end
