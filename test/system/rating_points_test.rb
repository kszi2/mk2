require "application_system_test_case"

class RatingPointsTest < ApplicationSystemTestCase
  setup do
    @rating_point = rating_points(:one)
  end

  test "visiting the index" do
    visit rating_points_url
    assert_selector "h1", text: "Rating points"
  end

  test "should create rating point" do
    visit rating_points_url
    click_on "New rating point"

    fill_in "Available points", with: @rating_point.available_points
    fill_in "Coursework", with: @rating_point.coursework_id
    fill_in "Descriptin", with: @rating_point.descriptin
    fill_in "Name", with: @rating_point.name
    click_on "Create Rating point"

    assert_text "Rating point was successfully created"
    click_on "Back"
  end

  test "should update Rating point" do
    visit rating_point_url(@rating_point)
    click_on "Edit this rating point", match: :first

    fill_in "Available points", with: @rating_point.available_points
    fill_in "Coursework", with: @rating_point.coursework_id
    fill_in "Descriptin", with: @rating_point.descriptin
    fill_in "Name", with: @rating_point.name
    click_on "Update Rating point"

    assert_text "Rating point was successfully updated"
    click_on "Back"
  end

  test "should destroy Rating point" do
    visit rating_point_url(@rating_point)
    click_on "Destroy this rating point", match: :first

    assert_text "Rating point was successfully destroyed"
  end
end
