class Message < ApplicationRecord
  belongs_to :conversation
  belongs_to :from, class_name: "User"
  belongs_to :to, class_name: "User"
  belongs_to :friendship

  has_encrypted :text

  validates :text, presence: true
  validates :from, presence: true
  validates :to, presence: true
  validates :friendship, presence: true
end
