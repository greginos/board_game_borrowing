class AddRefsToBorrowings < ActiveRecord::Migration[8.0]
  def change
    add_reference :borrowings, :user, null: false, foreign_key: true
    add_reference :borrowings, :board_game, null: false, foreign_key: true
  end
end
