require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      user = build(:user, email: 'test@example.com', password: 'password123')
      expect(user).to be_valid
    end

    it 'requires an email' do
      user = build(:user, email: nil, password: 'password123')
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("ne peut pas être vide")
    end

    it 'requires a valid email format' do
      user = build(:user, email: 'invalid_email', password: 'password123')
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("n'est pas valide")
    end

    it 'requires a unique email' do
      create(:user, email: 'test@example.com', password: 'password123')
      duplicate = build(:user, email: 'test@example.com', password: 'password123')
      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:email]).to include("a déjà été pris")
    end

    it 'requires a password' do
      user = build(:user, email: 'test@example.com', password: nil)
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include("ne peut pas être vide")
    end

    it 'requires a password with minimum length' do
      user = build(:user, email: 'test@example.com', password: '123')
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include("est trop court (minimum 6 caractères)")
    end
  end

  describe 'associations' do
    it { should have_many(:games) }
    it { should have_many(:borrowings) }
    it { should have_many(:borrowed_games).through(:borrowings).source(:game) }
    it { should have_many(:friendships) }
    it { should have_many(:friends).through(:friendships) }
    it { should have_many(:inverse_friendships).class_name('Friendship') }
    it { should have_many(:inverse_friends).through(:inverse_friendships).source(:user) }
  end

  describe 'friendship methods' do
    let(:user) { create(:user) }
    let(:friend) { create(:user) }

    describe '#send_friend_request' do
      it 'creates a pending friendship' do
        expect {
          user.send_friend_request(friend)
        }.to change(Friendship, :count).by(1)
        expect(Friendship.last.status).to eq('pending')
      end

      it 'does not create duplicate friendships' do
        user.send_friend_request(friend)
        expect {
          user.send_friend_request(friend)
        }.not_to change(Friendship, :count)
      end

      it 'returns false if trying to add self as friend' do
        expect(user.send_friend_request(user)).to be false
      end
    end

    describe '#accept_friend_request' do
      let!(:friendship) { create(:friendship, user: friend, friend: user, status: 'pending') }

      it 'accepts the friendship request' do
        user.accept_friend_request(friendship)
        expect(friendship.reload.status).to eq('accepted')
      end

      it 'returns false if user is not the friend' do
        expect(friend.accept_friend_request(friendship)).to be false
      end

      it 'returns false if friendship is not pending' do
        friendship.accept!
        expect(user.accept_friend_request(friendship)).to be false
      end
    end

    describe '#reject_friend_request' do
      let!(:friendship) { create(:friendship, user: friend, friend: user, status: 'pending') }

      it 'rejects the friendship request' do
        user.reject_friend_request(friendship)
        expect(friendship.reload.status).to eq('rejected')
      end

      it 'returns false if user is not the friend' do
        expect(friend.reject_friend_request(friendship)).to be false
      end

      it 'returns false if friendship is not pending' do
        friendship.accept!
        expect(user.reject_friend_request(friendship)).to be false
      end
    end

    describe '#remove_friend' do
      let!(:friendship) { create(:friendship, user: user, friend: friend, status: 'accepted') }

      it 'destroys the friendship' do
        expect {
          user.remove_friend(friend)
        }.to change(Friendship, :count).by(-1)
      end
    end

    describe '#friend?' do
      context 'when users are friends' do
        before { create(:friendship, user: user, friend: friend, status: 'accepted') }

        it 'returns true' do
          expect(user.friend?(friend)).to be true
        end
      end

      context 'when users are not friends' do
        it 'returns false' do
          expect(user.friend?(friend)).to be false
        end
      end

      context 'when friendship is pending' do
        before { create(:friendship, user: user, friend: friend, status: 'pending') }

        it 'returns false' do
          expect(user.friend?(friend)).to be false
        end
      end

      context 'when friendship is rejected' do
        before { create(:friendship, user: user, friend: friend, status: 'rejected') }

        it 'returns false' do
          expect(user.friend?(friend)).to be false
        end
      end
    end
  end
end
