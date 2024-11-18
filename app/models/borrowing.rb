class Borrowing < ApplicationRecord
  belongs_to :user
  belongs_to :board_game
end
