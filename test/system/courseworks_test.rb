require "application_system_test_case"

class CourseworksTest < ApplicationSystemTestCase
  setup do
    @coursework = courseworks(:one)
  end

  test "visiting the index" do
    visit courseworks_url
    assert_selector "h1", text: "Courseworks"
  end

  test "should create coursework" do
    visit courseworks_url
    click_on "New coursework"

    check "Active" if @coursework.active
    fill_in "Course", with: @coursework.course_id
    fill_in "Name", with: @coursework.name
    click_on "Create Coursework"

    assert_text "Coursework was successfully created"
    click_on "Back"
  end

  test "should update Coursework" do
    visit coursework_url(@coursework)
    click_on "Edit this coursework", match: :first

    check "Active" if @coursework.active
    fill_in "Course", with: @coursework.course_id
    fill_in "Name", with: @coursework.name
    click_on "Update Coursework"

    assert_text "Coursework was successfully updated"
    click_on "Back"
  end

  test "should destroy Coursework" do
    visit coursework_url(@coursework)
    click_on "Destroy this coursework", match: :first

    assert_text "Coursework was successfully destroyed"
  end
end
