class Game < ApplicationRecord
  belongs_to :user
  belongs_to :board_game
  has_many :borrowings

  enum :state, { new: 0, very_good: 1, good: 2, average: 3, used: 4 }, suffix: true
  scope :borrowable, -> { where(borrowable: true) }

  STATUS = {
    "Neuf" => :new,
    "Très bon état" => :very_good,
    "Bon état" => :good,
    "Correct" => :average,
    "Médiocre" => :used
  }
end
