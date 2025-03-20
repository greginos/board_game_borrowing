require 'rails_helper'

RSpec.describe BorrowingsController, type: :controller do
  let(:user) { create(:user) }
  let(:game) { create(:game) }
  let(:valid_attributes) { { game_id: game.id, start_date: Date.current, end_date: Date.current + 1.week } }

  before do
    sign_in user
  end

  describe "GET #new" do
    it "returns a success response" do
      get :new
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new borrowing" do
        expect {
          post :create, params: { borrowing: valid_attributes }
        }.to change(Borrowing, :count).by(1)
      end

      it "redirects to the created borrowing" do
        post :create, params: { borrowing: valid_attributes }
        expect(response).to redirect_to(Borrowing.last)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: { borrowing: { game_id: nil } }
        expect(response).to be_successful
      end
    end
  end

  describe "PATCH #update" do
    let(:borrowing) { create(:borrowing, user: user) }
    let(:new_attributes) { { end_date: Date.current + 2.weeks } }

    it "updates the requested borrowing" do
      patch :update, params: { id: borrowing.id, borrowing: new_attributes }
      borrowing.reload
      expect(borrowing.end_date).to eq(new_attributes[:end_date])
    end

    it "redirects to the borrowing" do
      patch :update, params: { id: borrowing.id, borrowing: new_attributes }
      expect(response).to redirect_to(borrowing)
    end
  end

  describe "DELETE #destroy" do
    let!(:borrowing) { create(:borrowing, user: user) }

    it "destroys the requested borrowing" do
      expect {
        delete :destroy, params: { id: borrowing.id }
      }.to change(Borrowing, :count).by(-1)
    end

    it "redirects to the borrowings list" do
      delete :destroy, params: { id: borrowing.id }
      expect(response).to redirect_to(borrowings_url)
    end
  end
end
