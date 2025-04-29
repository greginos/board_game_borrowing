class AddFriendshipIdToMessages < ActiveRecord::Migration[7.1]
  def change
    add_reference :messages, :friendship, null: true, foreign_key: true
  end
end
