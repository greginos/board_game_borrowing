class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: "User"

  validates :user, presence: true
  validates :friend, presence: true
  validates :status, presence: true, inclusion: { in: %w[pending accepted rejected] }
  validates :user_id, uniqueness: { scope: :friend_id }

  validate :not_self_friendship
  validate :not_duplicate_friendship

  def pending?
    status == "pending"
  end

  def accepted?
    status == "accepted"
  end

  def rejected?
    status == "rejected"
  end

  def accept!
    update(status: "accepted")
  end

  def reject!
    update(status: "rejected")
  end

  private

  def not_self_friendship
    errors.add(:friend, "ne peut pas être vous-même") if user == friend
  end

  def not_duplicate_friendship
    return unless user && friend

    if Friendship.exists?(user: [ user, friend ], friend: [ user, friend ])
      errors.add(:base, "cette amitié existe déjà")
    end
  end
end
