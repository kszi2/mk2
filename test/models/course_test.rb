require "test_helper"

class CourseTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "course with correct length and unique name is valid" do
    c = make_course
    assert c.valid?
  end

  test "course with too short name is invalid" do
    c = make_course(name: "a")
    refute c.valid?
  end

  test "course with too short name contains proper error" do
    c = make_course(name: "a")
    c.validate
    assert_match /is too short/, c.errors[:name].inject(:+)
  end

  test "course with duplicate name is invalid" do
    c = make_course(name: "Course 1")
    refute c.valid?
  end

  private

  def make_course(**kwargs)
    Course.new(name: 'test-course', **kwargs)
  end
end
