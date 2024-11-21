class RemoveReferencesFromBoardGames < ActiveRecord::Migration[8.0]
  def change
    remove_reference :board_games, :user, index: true, foreign_key: true
    remove_reference :borrowings, :board_game, index: true, foreign_key: true
    add_reference :borrowings, :game, index: true, foreign_key: true
  end
end
