class Borrowing < ApplicationRecord
  belongs_to :user
  belongs_to :game

  enum :status, { pending: 0, accepted: 1, rejected: 2 }, default: :pending

  scope :pending, -> { where(status: "pending") }
  scope :accepted, -> { where(status: "accepted") }
  scope :rejected, -> { where(status: "rejected") }
  scope :returned, -> { where(status: "returned") }

  validates :start_date, presence: true
  validates :end_date, presence: true
  validate :end_date_after_start_date
  validate :no_overlapping_borrowings


  def accept!
    accepted!
  end

  def reject!
    rejected!
  end

  def end_date_after_start_date
    return if end_date.blank? || start_date.blank?

    if end_date < start_date
      errors.add(:end_date, "doit être après la date de début")
    end
  end

  def no_overlapping_borrowings
    return if start_date.blank? || end_date.blank?

    overlapping = Borrowing.where(game: game)
                          .where.not(id: id)
                          .where.not(status: "rejected")
                          .where("(start_date <= ? AND end_date >= ?) OR (start_date <= ? AND end_date >= ?)",
                                end_date, start_date, start_date, start_date)

    if overlapping.exists?
      errors.add(:base, "Ce jeu est déjà emprunté pendant cette période")
    end
  end
end
