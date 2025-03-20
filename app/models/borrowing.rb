class Borrowing < ApplicationRecord
  belongs_to :user
  belongs_to :game

  validates :start_date, presence: true
  validates :end_date, presence: true
  validate :end_date_after_start_date

  private

  def end_date_after_start_date
    return if end_date.blank? || start_date.blank?

    if end_date < start_date
      errors.add(:end_date, "doit être postérieure à la date de début")
    end
  end
end
