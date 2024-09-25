require "test_helper"

class MarkingNoteTest < ActiveSupport::TestCase
  test "points cost equals effective cost if note is not fixed" do
    n = MarkingNote.new(points_cost: 42, fixed: false)
    assert_equal n.points_cost, n.effective_cost
  end

  test "effective cost is 0 if note is fixed" do
    n = MarkingNote.new(points_cost: 42, fixed: true)
    assert_equal 0, n.effective_cost
  end
end
