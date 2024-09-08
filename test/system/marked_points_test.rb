require "application_system_test_case"

class MarkedPointsTest < ApplicationSystemTestCase
  setup do
    @marked_point = marked_points(:one)
  end

  test "visiting the index" do
    visit marked_points_url
    assert_selector "h1", text: "Marked points"
  end

  test "should create marked point" do
    visit marked_points_url
    click_on "New marked point"

    fill_in "Rating point", with: @marked_point.rating_point_id
    fill_in "Submission", with: @marked_point.submission_id
    click_on "Create Marked point"

    assert_text "Marked point was successfully created"
    click_on "Back"
  end

  test "should update Marked point" do
    visit marked_point_url(@marked_point)
    click_on "Edit this marked point", match: :first

    fill_in "Rating point", with: @marked_point.rating_point_id
    fill_in "Submission", with: @marked_point.submission_id
    click_on "Update Marked point"

    assert_text "Marked point was successfully updated"
    click_on "Back"
  end

  test "should destroy Marked point" do
    visit marked_point_url(@marked_point)
    click_on "Destroy this marked point", match: :first

    assert_text "Marked point was successfully destroyed"
  end
end
