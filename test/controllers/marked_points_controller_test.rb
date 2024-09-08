require "test_helper"

class MarkedPointsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @marked_point = marked_points(:one)
  end

  test "should get index" do
    get marked_points_url
    assert_response :success
  end

  test "should get new" do
    get new_marked_point_url
    assert_response :success
  end

  test "should create marked_point" do
    assert_difference("MarkedPoint.count") do
      post marked_points_url, params: { marked_point: { rating_point_id: @marked_point.rating_point_id, submission_id: @marked_point.submission_id } }
    end

    assert_redirected_to marked_point_url(MarkedPoint.last)
  end

  test "should show marked_point" do
    get marked_point_url(@marked_point)
    assert_response :success
  end

  test "should get edit" do
    get edit_marked_point_url(@marked_point)
    assert_response :success
  end

  test "should update marked_point" do
    patch marked_point_url(@marked_point), params: { marked_point: { rating_point_id: @marked_point.rating_point_id, submission_id: @marked_point.submission_id } }
    assert_redirected_to marked_point_url(@marked_point)
  end

  test "should destroy marked_point" do
    assert_difference("MarkedPoint.count", -1) do
      delete marked_point_url(@marked_point)
    end

    assert_redirected_to marked_points_url
  end
end
