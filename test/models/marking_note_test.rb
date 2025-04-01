require "test_helper"

class MarkingNoteTest < ActiveSupport::TestCase
  setup do
    subm = Submission.create!(coursework: courseworks(:lab1),
                              student: students(:xaver_teszt),
                              group: groups(:group_lab1))
    @marked_point = MarkedPoint.create!(submission: subm, rating_point: rating_points(:lab1_complete_rating))
    @marking_note = MarkingNote.new(marked_point: @marked_point, points_cost: 3, fixed: false)
  end

  test "marking note can be found by public id" do
    assert_respond_to MarkingNote, :public_find
    assert_respond_to @marking_note, :public_id
  end

  test "valid marking note should be valid" do
    assert @marking_note.valid?
  end

  test "points_cost should be present" do
    @marking_note.points_cost = nil
    refute @marking_note.valid?
    assert @marking_note.errors.added?(:points_cost, :blank)
  end

  test "points_cost should be numerical" do
    @marking_note.points_cost = "abc"
    refute @marking_note.valid?
    assert @marking_note.errors.added?(:points_cost, :not_a_number, value: "abc")
  end

  test "fixed should allow true, false, or nil" do
    @marking_note.fixed = true
    assert @marking_note.valid?

    @marking_note.fixed = false
    assert @marking_note.valid?

    @marking_note.fixed = nil
    assert @marking_note.valid?
  end

  test "effective_cost should return 0 if fixed is true" do
    @marking_note.fixed = true
    assert_equal 0, @marking_note.effective_cost
  end

  test "effective_cost should return points_cost if not fixed" do
    assert_equal 3, @marking_note.effective_cost
  end

  test "criterion? should return true if marked_point is a criterion" do
    @marked_point.rating_point = rating_points(:lab1_crit)
    assert @marking_note.criterion?
  end

  test "criterion? should return false if marked_point is not a criterion" do
    @marked_point.rating_point = rating_points(:lab1_complete_rating)
    refute @marking_note.criterion?
  end

  test "name should always return 'Note'" do
    assert_equal "Note", @marking_note.name
  end
end
