require "test_helper"

class CourseworksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @course = courses(:course_with_lab)
    @coursework = courseworks(:w_lab_1)
  end

  test "should get index" do
    get course_courseworks_path(@course)
    assert_response :success
  end

  test "should get new" do
    get new_course_coursework_url @course
    assert_response :success
  end

  test "new contains input field for name" do
    get new_course_coursework_url @course
    assert_response :success
    assert_dom "wa-input[name='coursework[name]'][label='Name']", { count: 1 }
  end

  test "new contains input field for group type" do
    get new_course_coursework_url @course
    assert_response :success
    assert_dom "wa-select[name='coursework[for_type_id]'][label='For type']", { count: 1 }
  end

  test "new contains input field for group type with all types" do
    get new_course_coursework_url @course
    assert_response :success
    assert_dom "wa-select[name='coursework[for_type_id]'][label='For type']", { count: 1 } do
      @course.course_types.each do |type|
        assert_dom "wa-option[value='#{type.id}']", { text: type.name, count: 1 }
      end
    end
  end

  test "should create coursework" do
    assert_difference -> { Coursework.count }, 1 do
      post course_courseworks_url(@course), params: {
        coursework: { active: true, course_id: @course.id, name: "new work", for_type_id: @course.course_types.first.id, }
      }
    end

    assert_redirected_to course_coursework_url(@course, Coursework.last)
  end

  test "should show coursework" do
    get course_coursework_url(@course, @coursework)
    assert_response :success
  end

  test "should get edit" do
    get edit_course_coursework_url(@course, @coursework)
    assert_response :success
  end

  test "should update coursework" do
    assert_changes -> { @coursework.name }, to: "new name" do
      patch course_coursework_url(@course, @coursework), params: {
        coursework: { id: @coursework.id, active: @coursework.active, course_id: @coursework.course_id, name: "new name" }
      }
      @coursework.reload
    end
    assert_redirected_to course_coursework_url(@course, @coursework)
  end

  test "should destroy coursework" do
    assert_difference -> { Coursework.count }, -1 do
      delete course_coursework_url(@course, @coursework)
    end

    assert_redirected_to course_url(@course, page: :courseworks)
  end
end
