class AddBorrowableToGames < ActiveRecord::Migration[8.0]
  def change
    add_column :games, :borrowable, :boolean, null: false, default: false
  end
end
