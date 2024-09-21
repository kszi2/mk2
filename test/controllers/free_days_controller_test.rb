require "test_helper"

class FreeDaysControllerTest < ActionDispatch::IntegrationTest
  setup do
    @free_day = free_days(:one)
  end

  test "should get index" do
    get free_days_url
    assert_response :success
  end

  test "should get new" do
    get new_free_day_url
    assert_response :success
  end

  test "should create free_day" do
    assert_difference("FreeDay.count") do
      post free_days_url, params: { free_day: { from_day: @free_day.from_day, name: @free_day.name, to_day: @free_day.to_day } }
    end

    assert_redirected_to free_day_url(FreeDay.last)
  end

  test "should show free_day" do
    get free_day_url(@free_day)
    assert_response :success
  end

  test "should get edit" do
    get edit_free_day_url(@free_day)
    assert_response :success
  end

  test "should update free_day" do
    patch free_day_url(@free_day), params: { free_day: { from_day: @free_day.from_day, name: @free_day.name, to_day: @free_day.to_day } }
    assert_redirected_to free_day_url(@free_day)
  end

  test "should destroy free_day" do
    assert_difference("FreeDay.count", -1) do
      delete free_day_url(@free_day)
    end

    assert_redirected_to free_days_url
  end
end
