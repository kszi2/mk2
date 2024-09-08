require "application_system_test_case"

class MarkingNotesTest < ApplicationSystemTestCase
  setup do
    @marking_note = marking_notes(:one)
  end

  test "visiting the index" do
    visit marking_notes_url
    assert_selector "h1", text: "Marking notes"
  end

  test "should create marking note" do
    visit marking_notes_url
    click_on "New marking note"

    check "Fixed" if @marking_note.fixed
    fill_in "Marked points", with: @marking_note.marked_points_id
    fill_in "Points cost", with: @marking_note.points_cost
    fill_in "Reason", with: @marking_note.reason
    click_on "Create Marking note"

    assert_text "Marking note was successfully created"
    click_on "Back"
  end

  test "should update Marking note" do
    visit marking_note_url(@marking_note)
    click_on "Edit this marking note", match: :first

    check "Fixed" if @marking_note.fixed
    fill_in "Marked points", with: @marking_note.marked_points_id
    fill_in "Points cost", with: @marking_note.points_cost
    fill_in "Reason", with: @marking_note.reason
    click_on "Update Marking note"

    assert_text "Marking note was successfully updated"
    click_on "Back"
  end

  test "should destroy Marking note" do
    visit marking_note_url(@marking_note)
    click_on "Destroy this marking note", match: :first

    assert_text "Marking note was successfully destroyed"
  end
end
