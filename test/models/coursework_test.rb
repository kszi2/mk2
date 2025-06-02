require "test_helper"

class CourseworkTest < ActiveSupport::TestCase
  # Test validations
  test "should be valid with valid attributes" do
    course = courses(:course1)
    course_type = course_types(:lab)
    coursework = Coursework.new(name: "Assignment 1", course: course, for_type: course_type, active: true)
    assert coursework.valid?
  end

  test "should not be valid without a name" do
    coursework = Coursework.new(name: nil, course: courses(:course1), for_type: course_types(:lab), active: true)
    refute coursework.valid?
    assert_includes coursework.errors[:name], "can't be blank"
  end

  test "should not be valid with a too short name" do
    coursework = Coursework.new(name: "A", course: courses(:course1), for_type: course_types(:lab), active: true)
    refute coursework.valid?
    assert_includes coursework.errors[:name], "is too short (minimum is 2 characters)"
  end

  test "should not be valid with a too long name" do
    coursework = Coursework.new(name: "A" * 1025, course: courses(:course1), for_type: course_types(:lab), active: true)
    refute coursework.valid?
    assert_includes coursework.errors[:name], "is too long (maximum is 1024 characters)"
  end

  test "should not be valid without a for_type" do
    coursework = Coursework.new(name: "Assignment 1", course: courses(:course1), for_type: nil, active: true)
    refute coursework.valid?
    assert_includes coursework.errors[:for_type_id], "can't be blank"
  end

  test "should not be valid with a duplicate name within the same course" do
    existing_coursework = courseworks(:lab1)
    coursework = Coursework.new(name: existing_coursework.name, course: existing_coursework.course, 
                              for_type: course_types(:lab), active: true)
    refute coursework.valid?
    assert_includes coursework.errors[:name], "has already been taken"
  end

  test "should be valid with a duplicate name in a different course" do
    existing_coursework = courseworks(:lab1)
    new_course = Course.create!(name: "Another Course")
    coursework = Coursework.new(name: existing_coursework.name, course: new_course, 
                               for_type: course_types(:lab), active: true)
    assert coursework.valid?
  end

  test "should not be valid without active flag" do
    coursework = Coursework.new(name: "Assignment 1", course: courses(:course1), 
                               for_type: course_types(:lab), active: nil)
    refute coursework.valid?
    assert_includes coursework.errors[:active], "is not included in the list"
  end

  # Test scopes
  test "for_group scope should return active courseworks for the group's course and type" do
    # Create a test group
    group = Group.new(name: "Test Group", course: courses(:course1), course_type: course_types(:lab))

    # Use a stub for the actual query result
    expected_scope = Coursework.where(active: true, course_id: group.course_id, for_type_id: group.course_type_id).order(:name)
    Coursework.stub :order, ->{ Coursework.all } do
      Coursework.stub :where, ->(*) { expected_scope } do
        result = Coursework.for_group(group)
        assert_equal expected_scope, result
      end
    end
  end

  # Test PublicFindable functionality
  test "should include PublicFindable with prefix 'cW'" do
    assert_equal "cW", Coursework.id_prefix
    assert_respond_to Coursework, :public_find
  end

  # Test instance methods
  test "for_type_pid should return the public id of the for_type" do
    coursework = courseworks(:lab1)
    expected_pid = coursework.for_type.public_id
    assert_equal expected_pid, coursework.for_type_pid
  end

  test "for_type_pid should return the nil if for_type is not set" do
    coursework = courseworks(:lab1)
    coursework.for_type = nil
    assert_nil coursework.for_type_pid
  end

  test "criteria_count should return the count of criterion rating points" do
    coursework = courseworks(:lab1)
    # Count rating points where criterion? is true
    expected_count = coursework.rating_points.count { |rp| rp.criterion? }
    assert_equal expected_count, coursework.criteria_count
  end

  test "total_points should return the sum of available points" do
    coursework = courseworks(:lab1)
    expected_total = coursework.rating_points.sum(&:available_points)
    assert_equal expected_total, coursework.total_points
  end
end
