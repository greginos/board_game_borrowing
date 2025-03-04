class BorrowingsController < ApplicationController
  def create
    @borrowing = Borrowing.new(booking_params)
    @borrowing.game = Game.find(booking_params[:game_id])
    @borrowing.user = current_user || User.find(booking_params[:user_id])
    if @borrowing.save
      @borrowing.game.update(borrowable: false)
      redirect_to @borrowing.game.board_game
    else
      render "board_game/show"
    end
  end

  def new
    game = Game.find(params[:game_id])
    @borrowing = Borrowing.new(game: game)
    @board_game = @borrowing.game.board_game
  end

  private

  def booking_params
    params.require(:borrowing).permit(:start_date, :end_date, :user_id, :game_id)
  end
end
