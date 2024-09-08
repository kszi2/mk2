require "test_helper"

class RatingPointsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @rating_point = rating_points(:one)
  end

  test "should get index" do
    get rating_points_url
    assert_response :success
  end

  test "should get new" do
    get new_rating_point_url
    assert_response :success
  end

  test "should create rating_point" do
    assert_difference("RatingPoint.count") do
      post rating_points_url, params: { rating_point: { available_points: @rating_point.available_points, coursework_id: @rating_point.coursework_id, descriptin: @rating_point.descriptin, name: @rating_point.name } }
    end

    assert_redirected_to rating_point_url(RatingPoint.last)
  end

  test "should show rating_point" do
    get rating_point_url(@rating_point)
    assert_response :success
  end

  test "should get edit" do
    get edit_rating_point_url(@rating_point)
    assert_response :success
  end

  test "should update rating_point" do
    patch rating_point_url(@rating_point), params: { rating_point: { available_points: @rating_point.available_points, coursework_id: @rating_point.coursework_id, descriptin: @rating_point.descriptin, name: @rating_point.name } }
    assert_redirected_to rating_point_url(@rating_point)
  end

  test "should destroy rating_point" do
    assert_difference("RatingPoint.count", -1) do
      delete rating_point_url(@rating_point)
    end

    assert_redirected_to rating_points_url
  end
end
