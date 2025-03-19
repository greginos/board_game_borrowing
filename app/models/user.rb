class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :borrowings
  has_many :games
  has_many :board_games, through: :games

  def loaned_games
    Borrowing.joins(:game).where(games: { user_id: id })
  end
end
