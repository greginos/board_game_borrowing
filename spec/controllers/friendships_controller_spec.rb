require 'rails_helper'

RSpec.describe FriendshipsController, type: :controller do
  let(:user) { create(:user) }
  let(:friend) { create(:user) }
  let(:friendship) { create(:friendship, user: user, friend: friend) }

  before do
    sign_in user, scope: :user
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new friendship request' do
        expect {
          post :create, params: { user_id: user.id, friend_id: friend.id }
        }.to change(Friendship, :count).by(1)

        expect(response).to redirect_to(friend)
        expect(flash[:notice]).to eq("Demande d'amitié envoyée avec succès.")
      end
    end

    context 'when trying to befriend oneself' do
      it 'does not create a friendship' do
        expect {
          post :create, params: { user_id: user.id, friend_id: user.id }
        }.not_to change(Friendship, :count)

        expect(response).to redirect_to(user)
        expect(flash[:alert]).to eq("Impossible d'envoyer la demande d'amitié.")
      end
    end

    context 'when friendship already exists' do
      before { create(:friendship, user: user, friend: friend) }

      it 'does not create a duplicate friendship' do
        expect {
          post :create, params: { user_id: user.id, friend_id: friend.id }
        }.not_to change(Friendship, :count)

        expect(response).to redirect_to(friend)
        expect(flash[:alert]).to eq("Impossible d'envoyer la demande d'amitié.")
      end
    end
  end

  describe 'PATCH #update' do
    context 'when accepting a friendship request' do
      before { sign_in friend, scope: :user }

      it 'accepts the friendship request' do
        patch :update, params: { id: friendship.id, status: 'accepted' }

        expect(response).to redirect_to(friend)
        expect(flash[:notice]).to eq("Demande d'amitié acceptée.")
        expect(friendship.reload.status).to eq('accepted')
      end
    end

    context 'when rejecting a friendship request' do
      before { sign_in friend, scope: :user }

      it 'rejects the friendship request' do
        patch :update, params: { id: friendship.id, status: 'rejected' }

        expect(response).to redirect_to(friend)
        expect(flash[:notice]).to eq("Demande d'amitié refusée.")
        expect(friendship.reload.status).to eq('rejected')
      end
    end

    context 'when unauthorized user tries to update' do
      let(:unauthorized_user) { create(:user) }
      before { sign_in unauthorized_user, scope: :user }

      it 'redirects to root path' do
        patch :update, params: { id: friendship.id, status: 'accepted' }

        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('Action non autorisée.')
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when authorized user deletes friendship' do
      it 'destroys the friendship' do
        friendship # Create the friendship
        expect {
          delete :destroy, params: { id: friendship.id }
        }.to change(Friendship, :count).by(-1)

        expect(response).to redirect_to(user)
        expect(flash[:notice]).to eq("Amitié supprimée.")
      end
    end

    context 'when unauthorized user tries to delete' do
      let(:unauthorized_user) { create(:user) }
      before { sign_in unauthorized_user, scope: :user }

      it 'does not destroy the friendship' do
        friendship # Create the friendship
        expect {
          delete :destroy, params: { id: friendship.id }
        }.not_to change(Friendship, :count)

        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('Action non autorisée.')
      end
    end
  end
end
