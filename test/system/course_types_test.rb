require "application_system_test_case"

class CourseTypesTest < ApplicationSystemTestCase
  setup do
    @course_type = course_types(:one)
  end

  test "visiting the index" do
    visit course_types_url
    assert_selector "h1", text: "Course types"
  end

  test "should create course type" do
    visit course_types_url
    click_on "New course type"

    fill_in "Course", with: @course_type.course_id
    fill_in "Name", with: @course_type.name
    click_on "Create Course type"

    assert_text "Course type was successfully created"
    click_on "Back"
  end

  test "should update Course type" do
    visit course_type_url(@course_type)
    click_on "Edit this course type", match: :first

    fill_in "Course", with: @course_type.course_id
    fill_in "Name", with: @course_type.name
    click_on "Update Course type"

    assert_text "Course type was successfully updated"
    click_on "Back"
  end

  test "should destroy Course type" do
    visit course_type_url(@course_type)
    click_on "Destroy this course type", match: :first

    assert_text "Course type was successfully destroyed"
  end
end
