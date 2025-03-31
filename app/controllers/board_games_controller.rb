class BoardGamesController < ApplicationController
  before_action :set_board_game, only: [ :show, :edit, :update, :destroy ]

  def index
    @board_games = BoardGame.page(params[:page]).per(12)

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
      if BoardGame.find_by(ean: params[:ean])
        @board_game = BoardGame.find_by(ean: params[:ean])
        return @board_game
      end
      barcode_converter = BarcodeConverter.new(params[:ean])
      game_data = barcode_converter.convert

      if game_data.is_a?(Array) && game_data.size == 2
        @game_list = []
        game_data.each do |source_data|
          next unless source_data && source_data[:values]
          source_data[:values].each do |game|
            @game_list << {
              name: game[:name],
              callback_url: game[:callback_url],
              source: source_data[:origin]
            }
          end
        end
      elsif game_data.is_a?(Hash) && game_data[:values]
        @game_list = game_data[:values].map do |game|
          {
            name: game[:name],
            callback_url: game[:callback_url],
            source: game_data[:origin]
          }
        end
      elsif game_data.is_a?(Hash)
        game_info = game_data
      else
        game_info = barcode_converter.convert_with_converter(game_data[:callback_url], game_data[:origin].to_sym)
      end

      if game_info
        @game_list = nil
        @board_game.name = game_info[:name]
        @board_game.image_link = game_info[:image_link]
        @board_game.ean = game_info[:ean]
        @board_game.min_players = game_info[:min_players]
        @board_game.max_players = game_info[:max_players]
        @board_game.minimum_age = game_info[:minimum_age]
        @board_game.length = game_info[:length]
        @board_game.description = game_info[:description]
      end

      if params[:selected_game].present?
        # Si un jeu a été sélectionné, on récupère ses informations
        callback_url, source = params[:selected_game].split("|")
        converter = BarcodeConverter.new(params[:ean])
        game_info = converter.convert_with_converter(callback_url, source.to_sym)

        if game_info
          @game_list = nil

          @board_game.name = game_info[:name]
          @board_game.image_link = game_info[:image_link]
          @board_game.ean = game_info[:ean]
          @board_game.min_players = game_info[:min_players]
          @board_game.max_players = game_info[:max_players]
          @board_game.minimum_age = game_info[:minimum_age]
          @board_game.length = game_info[:length]
          @board_game.description = game_info[:description]
        end
      end
    end
  end

  def create
    filtered_params = board_game_params
    game_state = filtered_params.delete("game_state")
    @board_game = BoardGame.new(filtered_params)

    if @board_game.save
      Game.create(board_game: @board_game, user: current_user, state: Game::STATUS[game_state])
      if params[:add_another]
        redirect_to scan_board_games_path, notice: "Jeu créé avec succès ! Ajoutez-en un autre."
      else
        redirect_to @board_game, notice: "Le jeu a été créé avec succès !"
      end
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
    params.require(:board_game).permit(:name, :ean, :image_link, :min_players, :max_players, :minimum_age, :length, :game_state, :description, :selected_game)
  end
end
