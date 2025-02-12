require "test_helper"

class MarkedPointTest < ActiveSupport::TestCase
  setup do
    submission = Submission.create!(coursework: courseworks(:lab1), student: students(:xaver_teszt))
    @rating_point = RatingPoint.create!(name: "Accuracy", coursework: courseworks(:lab1), available_points: 10, ordering: 1)
    @marked_point = MarkedPoint.new(submission: submission, rating_point: @rating_point)
  end

  test "marked point can be found by public id" do
    assert_respond_to MarkedPoint, :public_find
    assert_respond_to @marked_point, :public_id
  end

  test "valid marked point should be valid" do
    assert @marked_point.valid?
  end

  test "should require a submission" do
    @marked_point.submission = nil
    refute @marked_point.valid?
    assert @marked_point.errors.added?(:submission, :blank)
  end

  test "should require a rating point" do
    @marked_point.rating_point = nil
    refute @marked_point.valid?
    assert @marked_point.errors.added?(:rating_point, :blank)
  end

  test "point_name should return the name of the rating point" do
    assert_equal "Accuracy", @marked_point.point_name
  end

  test "available_points should return rating_point's available_points" do
    assert_equal 10, @marked_point.available_points
  end

  test "marked_for should return available points minus total points cost" do
    @marked_point.stub(:total_points_cost, 4) do
      assert_equal 6, @marked_point.marked_for
    end
  end

  test "criterion? should return true if rating_point is a criterion" do
    @rating_point.stub(:criterion?, true) do
      assert @marked_point.criterion?
    end
  end

  test "failed_criterion? should return true if criterion and total points cost is not zero" do
    @rating_point.stub(:criterion?, true) do
      @marked_point.stub(:total_points_cost, 5) do
        assert @marked_point.failed_criterion?
      end
    end
  end

  test "failed_criterion? should return false if not a criterion" do
    @rating_point.stub(:criterion?, false) do
      refute @marked_point.failed_criterion?
    end
  end

  test "total_points_cost should sum non-fixed marking notes" do
    @marked_point.save!
    @marked_point.marking_notes.create!(points_cost: 3, fixed: false)
    @marked_point.marking_notes.create!(points_cost: 2, fixed: false)
    @marked_point.marking_notes.create!(points_cost: 5, fixed: true)

    assert_equal 5, @marked_point.total_points_cost
  end

  test "total_points_cost should return 0 if there are no marking notes" do
    assert_equal 0, @marked_point.total_points_cost
  end
end
