require "application_system_test_case"

class FreeDaysTest < ApplicationSystemTestCase
  setup do
    @free_day = free_days(:one)
  end

  test "visiting the index" do
    visit free_days_url
    assert_selector "h1", text: "Free days"
  end

  test "should create free day" do
    visit free_days_url
    click_on "New free day"

    fill_in "From day", with: @free_day.from_day
    fill_in "Name", with: @free_day.name
    fill_in "To day", with: @free_day.to_day
    click_on "Create Free day"

    assert_text "Free day was successfully created"
    click_on "Back"
  end

  test "should update Free day" do
    visit free_day_url(@free_day)
    click_on "Edit this free day", match: :first

    fill_in "From day", with: @free_day.from_day
    fill_in "Name", with: @free_day.name
    fill_in "To day", with: @free_day.to_day
    click_on "Update Free day"

    assert_text "Free day was successfully updated"
    click_on "Back"
  end

  test "should destroy Free day" do
    visit free_day_url(@free_day)
    click_on "Destroy this free day", match: :first

    assert_text "Free day was successfully destroyed"
  end
end
