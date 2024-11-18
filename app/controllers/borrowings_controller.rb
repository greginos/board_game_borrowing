class BorrowingsController < ApplicationController
  def create
    @board_game = BoardGame.find(params[:board_game_id])
    @booking = Borrowing.new(booking_params)
    @booking.board_game = @board_game
    @booking.user = current_user
    if @booking.save
      redirect_to @board_game
    else
      render "board_game/show"
    end
  end

  private

  def booking_params
    params.require(:booking).permit(:date)
  end
end
