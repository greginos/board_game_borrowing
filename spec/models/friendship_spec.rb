require 'rails_helper'

RSpec.describe Friendship, type: :model do
  let(:user) { create(:user) }
  let(:friend) { create(:user) }

  describe 'validations' do
    it 'is valid with valid attributes' do
      friendship = build(:friendship, user: user, friend: friend, status: 'pending')
      expect(friendship).to be_valid
    end

    it 'requires a user' do
      friendship = build(:friendship, friend: friend, status: 'pending')
      expect(friendship).not_to be_valid
      expect(friendship.errors[:user]).to include("doit exister")
    end

    it 'requires a friend' do
      friendship = build(:friendship, user: user, status: 'pending')
      expect(friendship).not_to be_valid
      expect(friendship.errors[:friend]).to include("doit exister")
    end

    it 'requires a status' do
      friendship = build(:friendship, user: user, friend: friend)
      expect(friendship).not_to be_valid
      expect(friendship.errors[:status]).to include("ne peut pas être vide")
    end

    it 'validates status inclusion' do
      friendship = build(:friendship, user: user, friend: friend, status: 'invalid')
      expect(friendship).not_to be_valid
      expect(friendship.errors[:status]).to include("n'est pas inclus dans la liste")
    end
  end

  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:friend).class_name('User') }
  end

  describe 'uniqueness' do
    it 'enforces unique friendship between users' do
      create(:friendship, user: user, friend: friend, status: 'pending')
      duplicate = build(:friendship, user: user, friend: friend, status: 'pending')
      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:user_id]).to include("a déjà été pris")
    end
  end

  describe 'custom validations' do
    it 'validates that user and friend are different' do
      friendship = build(:friendship, user: user, friend: user, status: 'pending')
      expect(friendship).not_to be_valid
      expect(friendship.errors[:friend]).to include("ne peut pas être vous-même")
    end
  end

  describe '#accept!' do
    let(:friendship) { create(:friendship, status: 'pending') }

    it 'changes status to accepted' do
      friendship.accept!
      expect(friendship.reload.status).to eq('accepted')
    end
  end

  describe '#reject!' do
    let(:friendship) { create(:friendship, status: 'pending') }

    it 'changes status to rejected' do
      friendship.reject!
      expect(friendship.reload.status).to eq('rejected')
    end
  end

  describe 'status methods' do
    let(:friendship) { create(:friendship, status: 'pending') }

    it '#pending? returns true when status is pending' do
      expect(friendship.pending?).to be true
    end

    it '#accepted? returns true when status is accepted' do
      friendship.accept!
      expect(friendship.accepted?).to be true
    end

    it '#rejected? returns true when status is rejected' do
      friendship.reject!
      expect(friendship.rejected?).to be true
    end
  end
end
