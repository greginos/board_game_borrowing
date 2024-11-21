class CreateBoardGames < ActiveRecord::Migration[8.0]
  def change
    create_table :board_games do |t|
      t.string :ean
      t.string :name
      t.timestamps
    end
  end
end
