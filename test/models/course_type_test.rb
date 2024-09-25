require "test_helper"

class CourseTypeTest < ActiveSupport::TestCase
  test "proper course type is valid" do
    c = make_ctype
    assert c.valid?
  end

  test "course type with duplicate name for given course is invalid" do
    c = make_ctype(name: course_types(:labor_1).name)
    refute c.valid?
  end

  test "course type with duplicate name for a different course is valid" do
    c = make_ctype(name: course_types(:gyak).name, course: courses(:course_with_biweekly_lab))
    assert c.valid?
  end

  test "course type with duplicate name for given course contains reports violation" do
    c = make_ctype(name: course_types(:labor_1).name)
    refute c.valid?
    assert_match /already been taken/, c.errors[:name].inject(:+)
  end

  test "course type with too short name is invalid" do
    c = make_ctype(name: "a")
    refute c.valid?
  end

  test "course type with too short name reports this" do
    c = make_ctype(name: "a")
    refute c.valid?
    assert_match /is too short/, c.errors[:name].inject(:+)
  end

  test "course type with too long name is invalid" do
    c = make_ctype(name: "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")
    refute c.valid?
  end

  test "course type with too long name reports this" do
    c = make_ctype(name: "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")
    refute c.valid?
    assert_match /is too long/, c.errors[:name].inject(:+)
  end

  test "course type without name is invalid" do
    c = make_ctype name: nil
    refute c.valid?
  end

  test "course type without name reports missing name" do
    c = make_ctype name: nil
    refute c.valid?
    assert_match /can't be blank/, c.errors[:name].inject(:+)
  end

  test "course type without course is invalid" do
    c = make_ctype course_id: nil
    refute c.valid?
  end

  test "course type without course reports missing course_id" do
    c = make_ctype course_id: nil
    refute c.valid?
    assert_match /can't be blank/, c.errors[:course_id].inject(:+)
  end

  test "course type's to_select_value returns list of id and name" do
    c = make_ctype
    assert_equal [c.id, c.name], c.to_select_value
  end

  private

  def make_ctype(**kwargs)
    CourseType.new(name: 'type', course_id: courses(:course_with_lab).id, **kwargs)
  end
end
