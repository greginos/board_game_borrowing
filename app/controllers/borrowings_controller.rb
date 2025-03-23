class BorrowingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_game, only: [ :new, :create ]
  before_action :set_borrowing, only: [ :update ]

  def create
    @borrowing = Borrowing.new(booking_params)
    @borrowing.game = @game
    @borrowing.user = current_user

    if can_borrow?
      if @borrowing.save
        @borrowing.game.update(borrowable: false)
        redirect_to @borrowing.game.board_game, notice: "Demande de prêt en cours"
      else
        render "board_game/show"
      end
    else
      redirect_to @game.board_game, alert: "Vous devez être ami avec le propriétaire pour emprunter ce jeu."
    end
  end

  def update
    if params[:status] == "accepted"
      @borrowing.accept!
      redirect_to @borrowing.game.board_game, notice: "Demande de prêt validée"
    elsif params[:status] == "rejected"
      @borrowing.reject!
      redirect_to current_user, notice: "Demande de prêt refus\u00E9e."
    else
      render "board_game/show"
    end
  end

  def new
    @borrowing = Borrowing.new(game: @game)
    @board_game = @borrowing.game.board_game
  end

  private

  def set_game
    game_id = params[:game_id] || booking_params[:game_id]
    @game = Game.find(game_id)
  end

  def booking_params
    params.require(:borrowing).permit(:start_date, :end_date, :game_id)
  end

  def can_borrow?
    @game.user.all_friends.include?(current_user)
  end
end
