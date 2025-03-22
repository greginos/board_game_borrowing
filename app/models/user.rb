class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable

  has_one_attached :avatar

  has_many :games
  has_many :board_games, through: :games
  has_many :borrowings
  has_many :borrowed_games, through: :borrowings, source: :game
  has_many :friendships
  has_many :friends, through: :friendships
  has_many :inverse_friendships, class_name: "Friendship"
  has_many :inverse_friends, through: :inverse_friendships, source: :user

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :pseudo, presence: true, uniqueness: true
  validates :avatar, content_type: [ "image/png", "image/jpeg", "image/gif" ], size: { less_than: 1.megabytes }

  def avatar_url
    if avatar.attached?
      avatar
    else
      "https://ui-avatars.com/api/?name=#{pseudo}&background=random"
    end
  end

  def send_friend_request(friend)
    return false if self == friend
    return false if friendship_with?(friend)

    friendships.create(friend: friend, status: "pending")
  end

  def accept_friend_request(friendship)
    return false unless friendship.friend == self
    return false unless friendship.pending?

    friendship.update(status: "accepted")
  end

  def reject_friend_request(friendship)
    return false unless friendship.friend == self
    return false unless friendship.pending?

    friendship.update(status: "rejected")
  end

  def remove_friend(friend)
    friendship = friendship_with(friend)
    friendship&.destroy
  end

  def friend?(friend)
    friendship = friendship_with(friend)
    return false unless friendship

    friendship.accepted?
  end

  def friendship_with(friend)
    direct = friendships.find_by(friend: friend)
    return direct if direct

    inverse = inverse_friendships.find_by(friend: self)
    return inverse if inverse

    nil
  end

  def friendship_with?(friend)
    friendship_with(friend).present?
  end

  def loaned_games
    Borrowing.joins(:game).where(games: { user_id: id })
  end

  def all_friends
    (friends + inverse_friends).uniq
  end

  def pending_friendships
    friendships.where(status: "pending")
  end

  def pending_inverse_friendships
    Friendship.where(friend: self, status: "pending")
  end
end
