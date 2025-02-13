class Game < ApplicationRecord
  belongs_to :user
  belongs_to :board_game
  has_many :borrowings

  scope :borrowable, -> { where(borrowable: true) }
end
