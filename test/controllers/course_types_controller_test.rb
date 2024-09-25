require "test_helper"

class CourseTypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @course = courses(:course_with_lab)
    @course_type = course_types(:labor_1)
  end

  test "index exists" do
    get course_course_types_url(@course)
    assert_response :success
  end

  test "index contains all types for course once" do
    get course_course_types_url(@course)
    assert_response :success
    @course.course_types.each do |type|
      assert_dom "td", { text: type.name, count: 1 }
    end
  end

  test "should get new" do
    get new_course_course_type_url @course
    assert_response :success
  end

  test "new contains input field for name" do
    get new_course_course_type_url @course
    assert_response :success
    assert_dom "wa-input[name='course_type[name]']", { count: 1 }
  end

  test "new contains label for name" do
    get new_course_course_type_url @course
    assert_response :success
    assert_dom "wa-input[label='Name']", { count: 1 }
  end

  test "should create course_type" do
    @course_type = CourseType.new(name: "controller-test-course-type", course: @course)
    assert_difference -> { CourseType.count } do
      post course_course_types_url(@course), params: {
        course_type: { course_id: @course_type.course_id, name: @course_type.name }
      }
    end

    assert_redirected_to course_course_type_url(@course, CourseType.last)
  end

  test "should show course_type" do
    get course_course_type_url(@course, @course_type)
    assert_response :success
  end

  test "show of course_type includes course type name" do
    get course_course_type_url(@course, @course_type)
    assert_response :success
    assert_dom "b", { count: 1, text: "Name:" }
    assert_dom "span", { count: 1, text: @course_type.name }
  end

  test "show of course_type includes containing course name" do
    get course_course_type_url(@course, @course_type)
    assert_response :success
    assert_dom "b", { count: 1, text: "Course:" }
    assert_dom "span", { count: 1, text: @course.name }
  end

  test "show has edit button to edit page of current course" do
    get course_course_type_url(@course, @course_type)
    assert_response :success
    assert_dom "wa-button[href='#{edit_course_course_type_path(@course, @course_type)}']", { count: 1, text: "Edit" }
  end

  test "show has back button to courses index" do
    get course_course_type_url(@course, @course_type)
    assert_response :success
    assert_dom "wa-button[href='#{course_path(@course, page: :course_types)}']", { count: 1, text: "Back" }
  end


  test "should get edit" do
    get edit_course_course_type_url(@course, @course_type)
    assert_response :success
  end

  test "edit contains input field for name" do
    get edit_course_course_type_url @course, @course_type
    assert_response :success
    assert_dom "wa-input[name='course_type[name]']", { count: 1 }
  end

  test "edit contains label for name" do
    get edit_course_course_type_url @course, @course_type
    assert_response :success
    assert_dom "wa-input[label='Name']", { count: 1 }
  end

  test "edit has show button to page of current course" do
    get edit_course_course_type_url(@course, @course_type)
    assert_response :success
    assert_dom "wa-button[href='#{course_course_type_path(@course, @course_type)}']", { count: 1, text: "Show" }
  end

  test "edit has back button to courses index" do
    get edit_course_course_type_url(@course, @course_type)
    assert_response :success
    assert_dom "wa-button[href='#{course_path(@course, page: :course_types)}']", { count: 1, text: "Back" }
  end

  test "edit has save button" do
    get edit_course_course_type_url(@course, @course_type)
    assert_response :success
    assert_dom "wa-button[type='submit']", { count: 1, text: "Save" }
  end

  test "should update course_type" do
    assert_changes -> { @course_type.name }, from: @course_type.name, to: "new name" do
      patch course_course_type_url(@course, @course_type), params: {
        course_type: { course_id: @course_type.course_id, name: "new name" }
      }
      @course_type.reload
    end
    assert_redirected_to course_course_type_url(@course, @course_type)
  end

  test "should destroy course_type" do
    assert_difference("CourseType.count", -1) do
      delete course_course_type_url(@course, @course_type)
    end

    assert_redirected_to course_url(@course, page: :course_types)
  end
end
