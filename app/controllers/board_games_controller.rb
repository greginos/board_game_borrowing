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

  def scan
    @board_game = BoardGame.new

    if params[:ean].present?
      # Supposons que vous ayez une méthode pour récupérer les infos du jeu à partir de l'EAN
      game_data = BarcodeConverter.new(params[:ean]).convert

      if game_data
        @board_game.name = game_data[:name]
        @board_game.image_link = game_data[:image_link]
        @board_game.ean = params[:ean] # On garde l'EAN entré par l'utilisateur
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

  def board_game_params
    params.require(:board_game).permit(:name, :ean, :image_link)
  end
end
