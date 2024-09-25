require "test_helper"

class CourseTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "course with correct length and unique name is valid" do
    c = make_course
    assert c.valid?
  end

  test "course without name is invalid" do
    c = make_course name: nil
    refute c.valid?
  end

  test "course without name reports missing name" do
    c = make_course name: nil
    refute c.valid?
    assert_match /can't be blank/, c.errors[:name].inject(:+)
  end

  test "course with too short name is invalid" do
    c = make_course(name: "a")
    refute c.valid?
  end

  test "course with too short name reports this" do
    c = make_course(name: "a")
    refute c.valid?
    assert_match /is too short/, c.errors[:name].inject(:+)
  end

  test "course with too long name is invalid" do
    c = make_course(name: "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")
    refute c.valid?
  end

  test "course with too long name reports this" do
    c = make_course(name: "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")
    refute c.valid?
    assert_match /is too long/, c.errors[:name].inject(:+)
  end

  test "course with duplicate name is invalid" do
    c = make_course(name: courses(:course_with_lab).name)
    refute c.valid?
  end

  test "course with duplicate name contains reports violation" do
    c = make_course(name: courses(:course_with_lab).name)
    refute c.valid?
    assert_match /already been taken/, c.errors[:name].inject(:+)
  end

  private

  def make_course(**kwargs)
    Course.new(name: 'test-course', **kwargs)
  end
end
