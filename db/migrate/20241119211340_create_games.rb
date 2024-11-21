class CreateGames < ActiveRecord::Migration[8.0]
  def change
    create_table :games do |t|
      t.references :user, null: false, foreign_key: true
      t.references :board_game, null: false, foreign_key: true

      t.timestamps
    end
  end
end
