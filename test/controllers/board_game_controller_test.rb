require "test_helper"

class BoardGameControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get board_game_index_url
    assert_response :success
  end

  test "should get new" do
    get board_game_new_url
    assert_response :success
  end

  test "should get show" do
    get board_game_show_url
    assert_response :success
  end

  test "should get edit" do
    get board_game_edit_url
    assert_response :success
  end
end
