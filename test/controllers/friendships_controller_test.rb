require "test_helper"

class FriendshipsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
    @friend = users(:two)
    @friendship = friendships(:one)
    sign_in @user
  end

  test "should create friendship request" do
    assert_difference("Friendship.count") do
      post user_friendships_path(@user), params: { friend_id: @friend.id }
    end

    assert_redirected_to user_path(@friend)
    assert_equal "Demande d'amitié envoyée avec succès.", flash[:notice]
  end

  test "should not create self-friendship" do
    assert_no_difference("Friendship.count") do
      post user_friendships_path(@user), params: { friend_id: @user.id }
    end

    assert_redirected_to user_path(@user)
    assert_equal "Impossible d'envoyer la demande d'amitié.", flash[:alert]
  end

  test "should not create duplicate friendship" do
    # Créer une première amitié
    post user_friendships_path(@user), params: { friend_id: @friend.id }

    # Tenter de créer une deuxième amitié avec le même ami
    assert_no_difference("Friendship.count") do
      post user_friendships_path(@user), params: { friend_id: @friend.id }
    end

    assert_redirected_to user_path(@friend)
    assert_equal "Impossible d'envoyer la demande d'amitié.", flash[:alert]
  end

  test "should accept friendship request" do
    sign_in @friend
    patch user_friendship_path(@friend, @friendship), params: { friendship: { status: "accepted" } }

    assert_redirected_to user_path(@friend)
    assert_equal "Demande d'amitié acceptée.", flash[:notice]
    @friendship.reload
    assert_equal "accepted", @friendship.status
  end

  test "should reject friendship request" do
    sign_in @friend
    patch user_friendship_path(@friend, @friendship), params: { friendship: { status: "rejected" } }

    assert_redirected_to user_path(@friend)
    assert_equal "Demande d'amitié refusée.", flash[:notice]
    @friendship.reload
    assert_equal "rejected", @friendship.status
  end

  test "should destroy friendship" do
    assert_difference("Friendship.count", -1) do
      delete user_friendship_path(@user, @friendship)
    end

    assert_redirected_to user_path(@user)
    assert_equal "Amitié supprimée.", flash[:notice]
  end

  test "should not accept friendship request from wrong user" do
    wrong_user = users(:three)
    sign_in wrong_user

    patch user_friendship_path(wrong_user, @friendship), params: { friendship: { status: "accepted" } }

    assert_redirected_to root_path
    assert_equal "Action non autorisée.", flash[:alert]
  end

  test "should not destroy friendship from wrong user" do
    wrong_user = users(:three)
    sign_in wrong_user

    assert_no_difference("Friendship.count") do
      delete user_friendship_path(wrong_user, @friendship)
    end

    assert_redirected_to root_path
    assert_equal "Action non autorisée.", flash[:alert]
  end
end
