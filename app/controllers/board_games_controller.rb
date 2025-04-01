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
    ean = params[:ean]
    selected_game = params[:selected_game]

    if ean.present? && BoardGame.find_by(ean: ean)
      return find_existing_board_game(ean)
    end

    if ean.present?
      game_data = BarcodeConverter.new(ean).convert
      process_game_data(game_data)
    end

    process_selected_game(selected_game, ean) if selected_game.present?


    @board_game
  end

  def create
    filtered_params = board_game_params
    game_state = filtered_params.delete("game_state")
    if board_game_params[:id].present?
      @board_game = BoardGame.find(board_game_params[:id])
    else
      @board_game = BoardGame.new(filtered_params)
    end
    if @board_game.id.present? || @board_game.save
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

  def find_existing_board_game(ean)
    @board_game = BoardGame.find_by(ean: ean)
    @board_game
  end

  def process_game_data(game_data)
    case game_data
    when nil, {}, []
      flash[:alert] = "Aucune information trouvée pour ce jeu." # or handle empty game_data
    when Array
      @game_list = extract_game_list_from_array(game_data)
    when Hash
      if game_data[:values]
        @game_list = extract_game_list_from_hash_values(game_data)
      else
        populate_board_game_from_hash(game_data)
      end
    else
      populate_board_game_from_remote_data(game_data)
    end
  end

  def extract_game_list_from_array(game_data)
    game_list = []
    game_data.each do |source_data|
      next unless source_data && source_data[:values]
      source_data[:values].each do |game|
        game_list << {
          name: game[:name],
          callback_url: game[:callback_url],
          source: source_data[:origin]
        }
      end
    end
    game_list
  end

  def extract_game_list_from_hash_values(game_data)
    game_data[:values].map do |game|
      {
        name: game[:name],
        callback_url: game[:callback_url],
        source: game_data[:origin]
      }
    end
  end

  def populate_board_game_from_hash(game_info)
    @game_list = nil
    @board_game.assign_attributes(
      name: game_info[:name],
      image_link: game_info[:image_link],
      ean: game_info[:ean],
      min_players: game_info[:min_players],
      max_players: game_info[:max_players],
      minimum_age: game_info[:minimum_age],
      length: game_info[:length],
      description: game_info[:description]
    )
  end

  def populate_board_game_from_remote_data(game_data)
    game_info = BarcodeConverter.new(params[:ean]).convert_with_converter(game_data[:callback_url], game_data[:origin].to_sym)
    populate_board_game_from_hash(game_info) if game_info
  end

  def process_selected_game(selected_game, ean)
    callback_url, source = selected_game.split("|")
    game_info = BarcodeConverter.new(ean).convert_with_converter(callback_url, source.to_sym)
    populate_board_game_from_hash(game_info) if game_info
  end

  def set_board_game
    board_game_id = params.dig(:board_game, :id) || params[:id]
    @board_game = BoardGame.find(board_game_id)
  end

  def search_params
    params.permit(:players, :age_min, :query, :commit)
  end

  def board_game_params
    params.require(:board_game).permit(:name, :ean, :image_link, :min_players, :max_players, :minimum_age, :length, :game_state, :description, :selected_game, :id)
  end
end
