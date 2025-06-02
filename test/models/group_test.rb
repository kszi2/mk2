require "test_helper"

class GroupTest < ActiveSupport::TestCase
  # Test validations
  test "should be valid with valid attributes" do
    course = courses(:course1)
    course_type = course_types(:lab)
    group = Group.new(
      name: "Test Group", 
      course: course, 
      course_type: course_type,
      first_date: Date.today,
      repeat_times: 10,
      day_difference: 7
    )
    assert group.valid?
  end

  test "should not be valid without a name" do
    group = Group.new(
      name: nil,
      course: courses(:course1),
      course_type: course_types(:lab),
      first_date: Date.today,
      repeat_times: 10,
      day_difference: 7
    )
    refute group.valid?
    assert_includes group.errors[:name], "can't be blank"
  end

  test "should not be valid with a duplicate name within the same course" do
    existing_group = groups(:group_lab1)
    group = Group.new(
      name: existing_group.name,
      course: existing_group.course,
      course_type: course_types(:lab),
      first_date: Date.today,
      repeat_times: 10,
      day_difference: 7
    )
    refute group.valid?
    assert_includes group.errors[:name], "has already been taken"
  end

  test "should be valid with a duplicate name in a different course" do
    existing_group = groups(:group_lab1)
    new_course = Course.create!(name: "Another Course")
    group = Group.new(
      name: existing_group.name,
      course: new_course,
      course_type: course_types(:lab),
      first_date: Date.today,
      repeat_times: 10,
      day_difference: 7
    )
    assert group.valid?
  end

  test "should not be valid without a first_date" do
    group = Group.new(
      name: "Test Group",
      course: courses(:course1),
      course_type: course_types(:lab),
      first_date: nil,
      repeat_times: 10,
      day_difference: 7
    )
    refute group.valid?
    assert_includes group.errors[:first_date], "can't be blank"
  end

  test "should not be valid without repeat_times" do
    group = Group.new(
      name: "Test Group",
      course: courses(:course1),
      course_type: course_types(:lab),
      first_date: Date.today,
      repeat_times: nil,
      day_difference: 7
    )
    refute group.valid?
    assert_includes group.errors[:repeat_times], "can't be blank"
  end

  test "should not be valid with repeat_times less than 0" do
    group = Group.new(
      name: "Test Group",
      course: courses(:course1),
      course_type: course_types(:lab),
      first_date: Date.today,
      repeat_times: -1,
      day_difference: 7
    )
    refute group.valid?
    assert_includes group.errors[:repeat_times], "is not included in the list"
  end

  test "should not be valid with repeat_times greater than 14" do
    group = Group.new(
      name: "Test Group",
      course: courses(:course1),
      course_type: course_types(:lab),
      first_date: Date.today,
      repeat_times: 15,
      day_difference: 7
    )
    refute group.valid?
    assert_includes group.errors[:repeat_times], "is not included in the list"
  end

  test "should not be valid without day_difference" do
    group = Group.new(
      name: "Test Group",
      course: courses(:course1),
      course_type: course_types(:lab),
      first_date: Date.today,
      repeat_times: 10,
      day_difference: nil
    )
    refute group.valid?
    assert_includes group.errors[:day_difference], "can't be blank"
  end

  test "should not be valid with day_difference less than 1" do
    group = Group.new(
      name: "Test Group",
      course: courses(:course1),
      course_type: course_types(:lab),
      first_date: Date.today,
      repeat_times: 10,
      day_difference: 0
    )
    refute group.valid?
    assert_includes group.errors[:day_difference], "is not included in the list"
  end

  test "should not be valid with day_difference greater than 98" do
    group = Group.new(
      name: "Test Group",
      course: courses(:course1),
      course_type: course_types(:lab),
      first_date: Date.today,
      repeat_times: 10,
      day_difference: 99
    )
    refute group.valid?
    assert_includes group.errors[:day_difference], "is not included in the list"
  end

  test "should not be valid without course_type on create" do
    group = Group.new(
      name: "Test Group",
      course: courses(:course1),
      course_type: nil,
      first_date: Date.today,
      repeat_times: 10,
      day_difference: 7
    )
    # Test in create context
    refute group.valid?(:create)
    assert_includes group.errors[:course_type_id], "can't be blank"
  end

  # Test PublicFindable functionality
  test "should include PublicFindable with prefix 'G'" do
    assert_equal "G", Group.id_prefix
    assert_respond_to Group, :public_find
  end

  # Test instance methods
  test "year should return the year of first_date" do
    group = Group.new(first_date: Date.new(2025, 9, 1))
    assert_equal 2025, group.year
  end

  test "semester should return the semester number of first_date" do
    # Create a stub for the semester_number method on Date
    semester_value = 1
    Date.any_instance.stubs(:semester_number).returns(semester_value)

    group = Group.new(first_date: Date.new(2025, 9, 1))
    assert_equal semester_value, group.semester
  end

  test "safe_course_type should return course type name when course_type is present" do
    course_type = course_types(:lab)
    group = Group.new(course_type: course_type)
    assert_equal course_type.name, group.safe_course_type
  end

  test "safe_course_type should return <unset> when course_type is nil" do
    group = Group.new(course_type: nil)
    assert_equal "<unset>", group.safe_course_type
  end

  test "group_works should call Coursework.for_group" do
    group = groups(:group_lab1)
    expected_result = ["mocked result"]
    Coursework.expects(:for_group).with(group).returns(expected_result)
    assert_equal expected_result, group.group_works
  end

  test "semester_text should return correct format for first semester" do
    # Mock first_semester? to return true
    Date.any_instance.stubs(:first_semester?).returns(true)
    group = Group.new(first_date: Date.new(2025, 9, 1))
    assert_equal "2025-2026/1", group.semester_text
  end

  test "semester_text should return correct format for second semester" do
    # Mock first_semester? to return false
    Date.any_instance.stubs(:first_semester?).returns(false)
    group = Group.new(first_date: Date.new(2026, 2, 1))
    assert_equal "2025-2026/2", group.semester_text
  end

  test "current? should return true if today is in the semester range" do
    today = Date.today
    semester_range = (today - 10..today + 10)
    Date.any_instance.stubs(:semester_range).returns(semester_range)

    group = Group.new(first_date: today)
    assert group.current?
  end

  test "current? should return false if today is not in the semester range" do
    today = Date.today
    semester_range = (today + 20..today + 40)
    Date.any_instance.stubs(:semester_range).returns(semester_range)

    group = Group.new(first_date: today)
    refute group.current?
  end
end
