require "test_helper"

class CoursesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @course = courses(:course_with_lab)
  end

  test "should get index" do
    get courses_url
    assert_response :success
  end

  test "should get new" do
    get new_course_url
    assert_response :success
  end

  test "new contains input field for name" do
    get new_course_url
    assert_response :success
    assert_dom "wa-input[name='course[name]']", { count: 1 }
  end

  test "new contains label for name" do
    get new_course_url
    assert_response :success
    assert_dom "wa-input[label='Name']", { count: 1 }
  end

  test "should create course" do
    assert_difference("Course.count", 1) do
      post courses_url, params: { course: { name: "new name" } }
    end

    assert_redirected_to course_url(Course.last)
  end

  test "should show course" do
    get course_url(@course)
    assert_response :success
  end

  test "show of course includes course name" do
    get course_url(@course)
    assert_response :success
    assert_dom "b", { count: 1, text: "Name:" }
    assert_dom "span", { count: 1, text: @course.name }
  end

  test "show of course has edit button to edit page of current course" do
    get course_url(@course)
    assert_response :success
    assert_dom "wa-button[href='#{edit_course_path(@course)}']", { count: 1, text: "Edit" }
  end

  test "show of course has back button to courses index" do
    get course_url(@course)
    assert_response :success
    assert_dom "wa-button[href='#{courses_path}']", { count: 1, text: "Back" }
  end

  test "should get edit" do
    get edit_course_url(@course)
    assert_response :success
  end

  test "edit contains input field for name" do
    get edit_course_url(@course)
    assert_response :success
    assert_dom "wa-input[name='course[name]']", { count: 1 }
  end

  test "edit contains label for name" do
    get edit_course_url(@course)
    assert_response :success
    assert_dom "wa-input[label='Name']", { count: 1 }
  end

  test "edit has show button to page of current course" do
    get edit_course_url(@course)
    assert_response :success
    assert_dom "wa-button[href='#{course_path(@course)}']", { count: 1, text: "Show" }
  end

  test "edit has back button to courses index" do
    get edit_course_url(@course)
    assert_response :success
    assert_dom "wa-button[href='#{courses_path}']", { count: 1, text: "Back" }
  end

  test "edit has save button" do
    get edit_course_url(@course)
    assert_response :success
    assert_dom "wa-button[type='submit']", { count: 1, text: "Save" }
  end

  test "should update course" do
    assert_changes -> { @course.name }, to: "new name" do
      patch course_url(@course), params: { course: { name: "new name" } }
      @course.reload
    end
    assert_redirected_to course_url(@course)
  end

  test "should destroy course" do
    assert_difference -> { Course.count }, -1 do
      delete course_url(@course)
    end

    assert_redirected_to courses_url
  end
end
