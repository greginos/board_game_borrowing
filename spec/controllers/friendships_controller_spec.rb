require 'rails_helper'

RSpec.describe FriendshipsController, type: :controller do
  let(:user) { create(:user) }
  let(:friend) { create(:user) }

  before do
    sign_in user
  end

  describe "POST #create" do
    it "creates a new friendship request" do
      expect {
        post :create, params: { friendship: { friend_id: friend.id } }
      }.to change(Friendship, :count).by(1)
    end

    it "sets the status to pending" do
      post :create, params: { friendship: { friend_id: friend.id } }
      expect(Friendship.last.status).to eq('pending')
    end

    it "redirects to the friend's profile" do
      post :create, params: { friendship: { friend_id: friend.id } }
      expect(response).to redirect_to(friend)
    end

    context "when friendship already exists" do
      before { create(:friendship, user: user, friend: friend, status: 'pending') }

      it "does not create a new friendship" do
        expect {
          post :create, params: { friendship: { friend_id: friend.id } }
        }.not_to change(Friendship, :count)
      end

      it "redirects to the friend profile with error message" do
        post :create, params: { friendship: { friend_id: friend.id } }
        expect(response).to redirect_to(friend)
        expect(flash[:alert]).to eq('Impossible d\'envoyer la demande d\'amitié.')
      end
    end
  end

  describe "PATCH #update" do
    let(:friendship) { create(:friendship, user: friend, friend: user, status: 'pending') }

    it "updates the friendship status to accepted" do
      patch :update, params: { id: friendship.id, friendship: { status: 'accepted' } }
      friendship.reload
      expect(friendship.status).to eq('accepted')
    end

    it "redirects to the friend's profile" do
      patch :update, params: { id: friendship.id, friendship: { status: 'accepted' } }
      expect(response).to redirect_to(friend)
    end

    context "when user is not the friend" do
      let(:other_user) { create(:user) }
      let(:other_friendship) { create(:friendship, user: other_user, friend: user, status: 'pending') }

      before { sign_in other_user }

      it "redirects to root path with error message" do
        patch :update, params: { id: friendship.id, friendship: { status: 'accepted' } }
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('Action non autorisée.')
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:friendship) { create(:friendship, user: user, friend: friend) }

    it "destroys the friendship" do
      expect {
        delete :destroy, params: { id: friendship.id }
      }.to change(Friendship, :count).by(-1)
    end

    it "redirects to the friend's profile" do
      delete :destroy, params: { id: friendship.id }
      expect(response).to redirect_to(friend)
    end

    context "when user is not involved" do
      let(:other_user) { create(:user) }
      let(:other_friendship) { create(:friendship, user: other_user, friend: friend) }

      before { sign_in other_user }

      it "does not destroy the friendship" do
        expect {
          delete :destroy, params: { id: friendship.id }
        }.not_to change(Friendship, :count)
      end

      it "redirects to root path with error message" do
        delete :destroy, params: { id: friendship.id }
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('Action non autorisée.')
      end
    end
  end
end
