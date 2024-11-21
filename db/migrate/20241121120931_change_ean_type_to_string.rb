class ChangeEanTypeToString < ActiveRecord::Migration[8.0]
  def change
    change_column :board_games, :ean, :string
  end
end
