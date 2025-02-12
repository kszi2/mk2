require "test_helper"

class StudentTest < ActiveSupport::TestCase
  setup do
    @student = Student.new(name: "Béla Teszt", neptun: "XYXYXY")
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
      assert  @student.errors.added?(:neptun, :invalid, value: invalid)
    end
  end

  test "neptun should be unique (case insensitive)" do
    @student.save!
    duplicate_student = Student.new(name: "Álmos Teszt", neptun: "xyxyxy")
    refute duplicate_student.valid?
    assert duplicate_student.errors.added?(:neptun, :taken, value: "xyxyxy")
  end
end
