class AddFavoritesToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :favorites, :integer, array: true, default: []
  end
end
