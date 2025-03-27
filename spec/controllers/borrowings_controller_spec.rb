require 'rails_helper'

RSpec.describe BorrowingsController, type: :controller do
  let(:user) { create(:user) }
  let(:board_game) { create(:board_game) }
  let!(:game) { create(:game, board_game: board_game, user: create(:user)) }
  let(:valid_attributes) { { start_date: Date.current, end_date: Date.current + 1.week, game_id: game.id } }

  before do
    sign_in user, scope: :user
  end

  describe "GET #new" do
    xit "returns a success response" do
      get new_game_borrowing_url(game_id: game.id)
      expect(response).to be_successful
    end
  end

  xdescribe "POST #create" do
    context "when user is friend with game owner" do
      before do
        create(:friendship, user: game.user, friend: user, status: 'accepted')
      end

      it "creates a new borrowing" do
        expect {
          post :create, params: { game_id: game.id, borrowing: valid_attributes }
        }.to change(Borrowing, :count).by(1)
      end

      it "redirects to the board game page" do
        post :create, params: { game_id: game.id, borrowing: valid_attributes }
        expect(response).to redirect_to(board_game)
        expect(flash[:notice]).to eq("Demande de prêt en cours")
      end

      it "sets the game as not borrowable" do
        post :create, params: { game_id: game.id, borrowing: valid_attributes }
        expect(game.reload.borrowable).to be false
      end
    end

    context "when user is not friend with game owner" do
      it "does not create a borrowing" do
        expect {
          post :create, params: { game_id: game.id, borrowing: valid_attributes }
        }.not_to change(Borrowing, :count)
      end

      it "redirects to board game with error message" do
        post :create, params: { game_id: game.id, borrowing: valid_attributes }
        expect(response).to redirect_to(board_game)
        expect(flash[:alert]).to eq("Vous devez être ami avec le propriétaire pour emprunter ce jeu.")
      end
    end
  end
end
