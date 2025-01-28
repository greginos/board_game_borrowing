class Game < ApplicationRecord
  belongs_to :user
  belongs_to :board_game
  has_many :borrowings
end
