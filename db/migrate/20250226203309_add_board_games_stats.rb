class AddBoardGamesStats < ActiveRecord::Migration[8.0]
  def change
    add_column :board_games, :min_players, :integer
    add_column :board_games, :max_players, :integer
    add_column :board_games, :minimum_age, :integer
    add_column :board_games, :length, :string
  end
end
