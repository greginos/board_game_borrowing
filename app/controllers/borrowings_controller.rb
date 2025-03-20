class BorrowingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_game, only: [ :new, :create ]

  def create
    @borrowing = Borrowing.new(booking_params)
    @borrowing.game = @game
    @borrowing.user = current_user

    if can_borrow?
      if @borrowing.save
        @borrowing.game.update(borrowable: false)
        redirect_to @borrowing.game.board_game, notice: "Jeu emprunté avec succès!"
      else
        render "board_game/show"
      end
    else
      redirect_to @game.board_game, alert: "Vous devez être ami avec le propriétaire pour emprunter ce jeu."
    end
  end

  def new
    @borrowing = Borrowing.new(game: @game)
    @board_game = @borrowing.game.board_game
  end

  private

  def set_game
    @game = Game.find(params[:game_id])
  end

  def booking_params
    params.require(:borrowing).permit(:start_date, :end_date)
  end

  def can_borrow?
    @game.user.all_friends.include?(current_user)
  end
end
