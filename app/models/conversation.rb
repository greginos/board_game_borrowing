class Conversation < ApplicationRecord
  belongs_to :user1, class_name: "User"
  belongs_to :user2, class_name: "User"
  has_many :messages, dependent: :destroy

  validates :user1_id, presence: true
  validates :user2_id, presence: true
  validates :user1_id, uniqueness: { scope: :user2_id }

  def other_user(current_user)
    user1 == current_user ? user2 : user1
  end

  def participants
    [ user1, user2 ]
  end
end
