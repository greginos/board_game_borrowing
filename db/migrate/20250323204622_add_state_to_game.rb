class AddStateToGame < ActiveRecord::Migration[8.0]
  def change
    add_column :games, :state, :integer
  end
end
