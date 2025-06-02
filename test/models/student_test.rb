require "test_helper"

class StudentTest < ActiveSupport::TestCase
  setup do
    @student = Student.new(name: "Béla Teszt", neptun: "XYXYXY")

    @course1 = Course.create!(name: "Course__1")
    @course1.course_types << CourseType.new(name: "Lecture__1")
    @course1.save!

    @course2 = Course.create!(name: "Course__2")
    @course2.course_types << CourseType.new(name: "Lecture__2")
    @course2.save!

    @group1 = Group.create!(name: "Group 1", course: @course1, course_type: @course1.course_types.first, first_date: Date.today)
    @group2 = Group.create!(name: "Group 2", course: @course2, course_type: @course2.course_types.first, first_date: Date.today)
    @coursework11 = Coursework.create!(name: "Assignment 1", course: @course1, for_type: @course1.course_types.first, active: true)
    @coursework12 = Coursework.create!(name: "Assignment 2", course: @course1, for_type: @course1.course_types.first, active: true)
    @coursework2 = Coursework.create!(name: "Assignment 2", course: @course2, for_type: @course2.course_types.first, active: true)
  end

  test "student can be found by public id" do
    assert_respond_to Student, :public_find
    assert_respond_to @student, :public_id
  end

  test "valid student should be valid" do
    assert @student.valid?
  end

  test "name should be present" do
    @student.name = ""
    refute @student.valid?
    assert @student.errors.added?(:name, :blank)
  end

  test "name length should be within range" do
    @student.name = "A"
    refute @student.valid?

    @student.name = "A" * 256
    refute @student.valid?
  end

  test "neptun should be present" do
    @student.neptun = ""
    refute @student.valid?
    assert @student.errors.added?(:neptun, :blank)
  end

  test "neptun should have exactly 6 characters" do
    @student.neptun = "ABC12"
    refute @student.valid?

    @student.neptun = "ABC1234"
    refute @student.valid?
  end

  InvalidNeptuns = ["ABC12#", "123@45", "A!B*C*"]
  InvalidNeptuns.each do |invalid|
    test "neptun should only allow letters and numbers (invalid: #{invalid})" do
      @student.neptun = invalid
      refute @student.valid?, "#{invalid.inspect} should be invalid"
      assert @student.errors.added?(:neptun, :invalid, value: invalid)
    end
  end

  test "neptun should be unique (case insensitive)" do
    @student.save!
    duplicate_student = Student.new(name: "Álmos Teszt", neptun: "xyxyxy")
    refute duplicate_student.valid?
    assert duplicate_student.errors.added?(:neptun, :taken, value: "xyxyxy")
  end

  # Test instance methods
  test "results should return empty hash for student with no submissions" do
    assert_equal({}, @student.results)
  end

  test "results should organize submissions by course, group, and coursework" do
    @student.stubs(:submissions).returns(
      [
        new_submission(@group1, @coursework11, 10, 8)
      ])

    # Expected structure
    expected_results = {
      @course1 => {
        @group1 => {
          "Assignment 1" => { total: 10, achieved: 8 }
        }
      }
    }

    assert_equal expected_results, @student.results
  end

  test "results should handle multiple submissions for the same student" do
    @student.stubs(:submissions).returns(
      [
        new_submission(@group1, @coursework11, 10, 7),
        new_submission(@group2, @coursework2, 20, 18)
      ])

    # Expected structure
    expected_results = {
      @course1 => {
        @group1 => {
          "Assignment 1" => { total: 10, achieved: 7 }
        }
      },
      @course2 => {
        @group2 => {
          "Assignment 2" => { total: 20, achieved: 18 }
        }
      }
    }

    assert_equal expected_results, @student.results
  end

  test "results should handle multiple courseworks in the same group" do
    @student.stubs(:submissions).returns(
      [
        new_submission(@group1, @coursework11, 10, 7),
        new_submission(@group1, @coursework12, 15, 12)
      ])

    # Expected structure
    expected_results = {
      @course1 => {
        @group1 => {
          "Assignment 1" => { total: 10, achieved: 7 },
          "Assignment 2" => { total: 15, achieved: 12 }
        }
      }
    }

    assert_equal expected_results, @student.results
  end

  private

  def new_submission(group, coursework, total_points, marked_for)
    Submission.new(student: @student, group: group, coursework: coursework).tap do |submission|
      submission.stubs(:total_points).returns(total_points)
      submission.stubs(:marked_for).returns(marked_for)
    end
  end
end
