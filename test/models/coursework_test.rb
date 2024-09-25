require "test_helper"

class CourseworkTest < ActiveSupport::TestCase
  test "properly constructed coursework without points is valid" do
    c = make_coursework
    assert c.valid?, c.errors.full_messages
  end

  test "coursework without name reports missing name" do
    c = make_coursework name: nil
    refute c.valid?
    assert_match /can't be blank/, c.errors[:name].inject(:+)
  end

  test "coursework with too short name is invalid" do
    c = make_coursework(name: "a")
    refute c.valid?
  end

  test "coursework with too short name reports this" do
    c = make_coursework(name: "a")
    refute c.valid?
    assert_match /is too short/, c.errors[:name].inject(:+)
  end

  test "coursework with too long name is invalid" do
    c = make_coursework(name: "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")
    refute c.valid?
  end

  test "coursework with too long name reports this" do
    c = make_coursework(name: "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")
    refute c.valid?
    assert_match /is too long/, c.errors[:name].inject(:+)
  end

  test "coursework with duplicate name for a different course is valid" do
    c = make_coursework(name: courseworks(:bw_lab_1).name, course: courses(:course_with_lab))
    assert c.valid?
  end

  test "coursework with duplicate name for given course is invalid" do
    c = make_coursework(name: courseworks(:w_lab_1).name)
    refute c.valid?
  end

  test "coursework with duplicate name for given course contains reports violation" do
    c = make_coursework(name: courseworks(:w_lab_1).name)
    refute c.valid?
    assert_match /already been taken/, c.errors[:name].inject(:+)
  end

  test "coursework without for_type is invalid" do
    c = make_coursework for_type: nil
    refute c.valid?
  end

  test "coursework without for_type reports missing value" do
    c = make_coursework for_type: nil
    refute c.valid?
    assert_match /can't be blank/, c.errors[:for_type_id].inject(:+)
  end

  test "coursework active=nil is invalid" do
    c = make_coursework active: nil
    refute c.valid?
  end

  test "coursework active=true is valid" do
    c = make_coursework active: true
    assert c.valid?
  end

  test "coursework active=false is valid" do
    c = make_coursework active: false
    assert c.valid?
  end

  test "coursework without ratings has 0 criteria" do
    c = make_coursework
    assert_equal 0, c.criteria_count
  end

  test "coursework without ratings has 0 points" do
    c = make_coursework
    assert_equal 0, c.total_points
  end

  test "coursework with all numeric ratings has 0 criteria" do
    c = make_coursework
    c.rating_points << RatingPoint.new(name: "aaa", available_points: 1)
    c.rating_points << RatingPoint.new(name: "aaa2", available_points: 1)
    assert_equal 0, c.criteria_count
  end

  test "coursework with ratings has sum of members as total points" do
    c = make_coursework
    c.rating_points << RatingPoint.new(name: "aaa", available_points: 1)
    c.rating_points << RatingPoint.new(name: "aaa2", available_points: 1)
    assert_equal 2, c.total_points
  end

  test "coursework with criterion ratings has correct number of criteria" do
    c = make_coursework
    c.rating_points << RatingPoint.new(name: "aaa", available_points: 0)
    c.rating_points << RatingPoint.new(name: "aaa2", available_points: 0)
    assert_equal 2, c.criteria_count
  end

  test "coursework with all criterion ratings has 0 points" do
    c = make_coursework
    c.rating_points << RatingPoint.new(name: "aaa", available_points: 0)
    c.rating_points << RatingPoint.new(name: "aaa2", available_points: 0)
    assert_equal 0, c.total_points
  end

  private

  def make_coursework(**kwargs)
    Coursework.new(course: courses(:course_with_lab),
                   name: "hf",
                   active: true,
                   for_type_id: course_types(:labor_1).id,
                   **kwargs)
  end
end
