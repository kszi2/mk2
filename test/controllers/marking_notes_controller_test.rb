require "test_helper"

class MarkingNotesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @marking_note = marking_notes(:one)
  end

  test "should get index" do
    get marking_notes_url
    assert_response :success
  end

  test "should get new" do
    get new_marking_note_url
    assert_response :success
  end

  test "should create marking_note" do
    assert_difference("MarkingNote.count") do
      post marking_notes_url, params: { marking_note: { fixed: @marking_note.fixed, marked_points_id: @marking_note.marked_points_id, points_cost: @marking_note.points_cost, reason: @marking_note.reason } }
    end

    assert_redirected_to marking_note_url(MarkingNote.last)
  end

  test "should show marking_note" do
    get marking_note_url(@marking_note)
    assert_response :success
  end

  test "should get edit" do
    get edit_marking_note_url(@marking_note)
    assert_response :success
  end

  test "should update marking_note" do
    patch marking_note_url(@marking_note), params: { marking_note: { fixed: @marking_note.fixed, marked_points_id: @marking_note.marked_points_id, points_cost: @marking_note.points_cost, reason: @marking_note.reason } }
    assert_redirected_to marking_note_url(@marking_note)
  end

  test "should destroy marking_note" do
    assert_difference("MarkingNote.count", -1) do
      delete marking_note_url(@marking_note)
    end

    assert_redirected_to marking_notes_url
  end
end
