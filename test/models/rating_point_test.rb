require "test_helper"

class RatingPointTest < ActiveSupport::TestCase
  setup do
    @coursework = courseworks(:lab1)
    @rating_point = RatingPoint.new(name: "Accuracy",
                                    coursework: @coursework,
                                    ordering: 1,
                                    category: "Grading",
                                    available_points: 10)
  end

  test "Rating Point can be found by public id" do
    assert_respond_to RatingPoint, :public_find
    assert_respond_to @rating_point, :public_id
  end

  test "valid rating point should be valid" do
    assert @rating_point.valid?
  end

  test "name should be present" do
    @rating_point.name = ""
    refute @rating_point.valid?
    assert @rating_point.errors.added?(:name, :blank)
  end

  test "name should be unique within the same coursework" do
    @rating_point.save!
    duplicate_rating_point = RatingPoint.new(name: "Accuracy", coursework: @coursework)
    refute duplicate_rating_point.valid?
    assert duplicate_rating_point.errors.added?(:name, :taken, value: "Accuracy")
  end

  test "ordering should be an integer greater than or equal to 0" do
    @rating_point.ordering = -1
    refute @rating_point.valid?
    assert @rating_point.errors.added?(:ordering,
                                       :greater_than_or_equal_to,
                                       value: -1,
                                       count: 0)
  end

  test "ordering can be nil" do
    @rating_point.ordering = nil
    assert @rating_point.valid?
  end

  test "category length should be within range" do
    @rating_point.category = ""
    refute @rating_point.valid?

    @rating_point.category = "A" * 33
    refute @rating_point.valid?
  end

  test "category can be nil" do
    @rating_point.category = nil
    assert @rating_point.valid?
  end

  test "available points should be an integer greater than or equal to 0" do
    @rating_point.available_points = -5
    refute @rating_point.valid?
    assert @rating_point.errors.added?(:available_points,
                                       :greater_than_or_equal_to,
                                       count: 0,
                                       value: -5)
  end

  test "criterion? should return true if available points are 0" do
    @rating_point.available_points = 0
    assert @rating_point.criterion?
  end

  test "criterion? should return false if available points are greater than 0" do
    refute @rating_point.criterion?
  end
end
