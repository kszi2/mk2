require "test_helper"

class CourseworksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @coursework = courseworks(:one)
  end

  test "should get index" do
    get courseworks_url
    assert_response :success
  end

  test "should get new" do
    get new_coursework_url
    assert_response :success
  end

  test "should create coursework" do
    assert_difference("Coursework.count") do
      post courseworks_url, params: { coursework: { active: @coursework.active, course_id: @coursework.course_id, name: @coursework.name } }
    end

    assert_redirected_to coursework_url(Coursework.last)
  end

  test "should show coursework" do
    get coursework_url(@coursework)
    assert_response :success
  end

  test "should get edit" do
    get edit_coursework_url(@coursework)
    assert_response :success
  end

  test "should update coursework" do
    patch coursework_url(@coursework), params: { coursework: { active: @coursework.active, course_id: @coursework.course_id, name: @coursework.name } }
    assert_redirected_to coursework_url(@coursework)
  end

  test "should destroy coursework" do
    assert_difference("Coursework.count", -1) do
      delete coursework_url(@coursework)
    end

    assert_redirected_to courseworks_url
  end
end
