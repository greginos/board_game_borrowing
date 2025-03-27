require 'rails_helper'

RSpec.describe Borrowing, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:start_date) }
    it { should validate_presence_of(:end_date) }
  end

  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:game) }
  end

  describe 'custom validations' do
    let(:borrowing) { build(:borrowing, start_date: Date.current, end_date: Date.current - 1.day) }

    it 'validates that end_date is after start_date' do
      expect(borrowing).not_to be_valid
      expect(borrowing.errors[:end_date]).to include("doit être après la date de début")
    end

    it 'is valid when end_date is after start_date' do
      borrowing.end_date = Date.current + 1.day
      expect(borrowing).to be_valid
    end
  end
end
