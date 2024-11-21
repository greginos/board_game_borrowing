class AddColumnImageLinkToBoardGames < ActiveRecord::Migration[8.0]
  def change
    add_column :board_games, :image_link, :string
  end
end
