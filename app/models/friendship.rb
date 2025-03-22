class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: "User"

  validates :user_id, presence: true
  validates :friend_id, presence: true
  validates :status, presence: true

  enum :status, { pending: 0, accepted: 1, rejected: 2 }, default: :pending

  validates :user_id, uniqueness: { scope: :friend_id }

  validate :not_self_friendship, on: :create
  validate :not_duplicate_friendship, on: :create

  def accept!
    update!(status: :accepted)
  end

  def reject!
    update!(status: :rejected)
  end

  private

  def not_self_friendship
    if user_id == friend_id
      errors.add(:friend_id, "ne peut pas être le même que l'utilisateur")
    end
  end

  def not_duplicate_friendship
    if Friendship.exists?(user_id: user_id, friend_id: friend_id) ||
       Friendship.exists?(user_id: friend_id, friend_id: user_id)
      errors.add(:friend_id, "cette amitié existe déjà")
    end
  end
end
