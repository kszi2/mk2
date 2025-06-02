require "test_helper"

class CourseTest < ActiveSupport::TestCase
  # Test validations
  test "should be valid with valid attributes" do
    course = Course.new(name: "Computer Science")
    assert course.valid?
  end

  test "should not be valid without a name" do
    course = Course.new(name: nil)
    refute course.valid?
    assert_includes course.errors[:name], "can't be blank"
  end

  test "should not be valid with a too short name" do
    course = Course.new(name: "A")
    refute course.valid?
    assert_includes course.errors[:name], "is too short (minimum is 2 characters)"
  end

  test "should not be valid with a too long name" do
    course = Course.new(name: "A" * 33)
    refute course.valid?
    assert_includes course.errors[:name], "is too long (maximum is 32 characters)"
  end

  test "should not be valid with a duplicate name" do
    existing_course = courses(:course1)
    course = Course.new(name: existing_course.name)
    refute course.valid?
    assert_includes course.errors[:name], "has already been taken"
  end

  # Test PublicFindable functionality
  test "should include PublicFindable with prefix 'C'" do
    assert_equal "C", Course.id_prefix
    assert_respond_to Course, :public_find
  end

  test "should find course by public id" do
    course = courses(:course1)
    encoded_id = ApplicationRecord.encode_id(Course, course.id).to_s

    # Mock ApplicationRecord.decode_id to return the raw ID when given the encoded ID
    ApplicationRecord.stub(:decode_id, course.id) do
      assert_equal course, Course.public_find(encoded_id)
    end
  end
end
