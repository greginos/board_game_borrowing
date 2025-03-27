class Game < ApplicationRecord
  belongs_to :user
  belongs_to :board_game
  has_many :borrowings

  enum :state, { new: 0, very_good: 1, good: 2, average: 3, used: 4 }, suffix: true
  scope :borrowable, -> { where(borrowable: true) }
  # scope :from_friends, ->(user) {
  #   joins("INNER JOIN friendships ON (friendships.user_id = games.user_id AND friendships.friend_id = #{user.id}) OR (friendships.friend_id = games.user_id AND friendships.user_id = #{user.id})")
  #   .where(friendships: { status: :accepted })
  # }

  STATUS = {
    "Neuf" => :new,
    "Très bon état" => :very_good,
    "Bon état" => :good,
    "Correct" => :average,
    "Médiocre" => :used
  }

  def self.from_friends(user)
    joins(:user).where(users: { id: user.all_friends.pluck(:id) })
  end
end
