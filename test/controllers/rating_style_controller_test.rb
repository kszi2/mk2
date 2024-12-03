require "test_helper"

class RatingStyleControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get rating_style_index_url
    assert_response :success
  end

  test "should get show" do
    get rating_style_show_url
    assert_response :success
  end

  test "should get edit" do
    get rating_style_edit_url
    assert_response :success
  end

  test "should get update" do
    get rating_style_update_url
    assert_response :success
  end

  test "should get destroy" do
    get rating_style_destroy_url
    assert_response :success
  end
end
