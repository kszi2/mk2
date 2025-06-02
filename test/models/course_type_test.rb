require "test_helper"

class CourseTypeTest < ActiveSupport::TestCase
  # Test validations
  test "should be valid with valid attributes" do
    course = courses(:course1)
    course_type = CourseType.new(name: "Lecture", course: course)
    assert course_type.valid?
  end

  test "should not be valid without a name" do
    course_type = CourseType.new(name: nil, course: courses(:course1))
    refute course_type.valid?
    assert_includes course_type.errors[:name], "can't be blank"
  end

  test "should not be valid with a too short name" do
    course_type = CourseType.new(name: "A", course: courses(:course1))
    refute course_type.valid?
    assert_includes course_type.errors[:name], "is too short (minimum is 2 characters)"
  end

  test "should not be valid with a too long name" do
    course_type = CourseType.new(name: "A" * 33, course: courses(:course1))
    refute course_type.valid?
    assert_includes course_type.errors[:name], "is too long (maximum is 32 characters)"
  end

  test "should not be valid without a course" do
    course_type = CourseType.new(name: "Lecture", course: nil)
    refute course_type.valid?
    assert_includes course_type.errors[:course_id], "can't be blank"
  end

  test "should not be valid with a duplicate name within the same course" do
    existing_course_type = course_types(:lab)
    course_type = CourseType.new(name: existing_course_type.name, course: existing_course_type.course)
    refute course_type.valid?
    assert_includes course_type.errors[:name], "has already been taken"
  end

  test "should be valid with a duplicate name in a different course" do
    existing_course_type = course_types(:lab)
    new_course = Course.create!(name: "Another Course")
    course_type = CourseType.new(name: existing_course_type.name, course: new_course)
    assert course_type.valid?
  end

  # Test PublicFindable functionality
  test "should include PublicFindable with prefix 'cT'" do
    assert_equal "cT", CourseType.id_prefix
    assert_respond_to CourseType, :public_find
  end

  # Test instance methods
  test "to_select_value should return an array with id and name" do
    course_type = course_types(:lab)
    assert_equal [course_type.id, course_type.name], course_type.to_select_value
  end
end
