require "test_helper"

class FreeDayTest < ActiveSupport::TestCase
  # Test validations
  test "should be valid with valid attributes" do
    free_day = FreeDay.new(name: "Christmas", from_day: Date.new(2025, 12, 25))
    assert free_day.valid?
  end

  test "should be valid with valid range attributes" do
    free_day = FreeDay.new(
      name: "Winter Break", 
      from_day: Date.new(2025, 12, 24), 
      to_day: Date.new(2025, 12, 26)
    )
    assert free_day.valid?
  end

  test "should not be valid without a name" do
    free_day = FreeDay.new(name: nil, from_day: Date.new(2025, 12, 25))
    refute free_day.valid?
    assert_includes free_day.errors[:name], "can't be blank"
  end

  test "should not be valid without a from_day" do
    free_day = FreeDay.new(name: "Christmas", from_day: nil)
    refute free_day.valid?
    assert_includes free_day.errors[:from_day], "can't be blank"
  end

  test "should not be valid if to_day is before from_day" do
    free_day = FreeDay.new(
      name: "Invalid Range", 
      from_day: Date.new(2025, 12, 25), 
      to_day: Date.new(2025, 12, 24)
    )
    refute free_day.valid?
    assert_includes free_day.errors[:to_day], "must be greater than or equal to 2025-12-25"
  end

  test "should not be valid with duplicate name for same from_day" do
    FreeDay.create!(
      name: "Christmas", 
      from_day: Date.new(2025, 12, 25)
    )
    duplicate = FreeDay.new(
      name: "Christmas", 
      from_day: Date.new(2025, 12, 25)
    )
    refute duplicate.valid?
    assert_includes duplicate.errors[:name], "has already been taken"
  end

  test "should be valid with same name but different from_day" do
    FreeDay.create!(
      name: "Christmas", 
      from_day: Date.new(2025, 12, 25)
    )
    not_duplicate = FreeDay.new(
      name: "Christmas", 
      from_day: Date.new(2024, 12, 25)
    )
    assert not_duplicate.valid?
  end

  test "should not be valid with same name case insensitive" do
    FreeDay.create!(
      name: "Christmas", 
      from_day: Date.new(2025, 12, 25)
    )
    duplicate = FreeDay.new(
      name: "christmas", 
      from_day: Date.new(2025, 12, 25)
    )
    refute duplicate.valid?
    assert_includes duplicate.errors[:name], "has already been taken"
  end

  # Test PublicFindable functionality
  test "should include PublicFindable with prefix 'F'" do
    assert_equal "F", FreeDay.id_prefix
    assert_respond_to FreeDay, :public_find
  end

  # Test instance methods
  test "duration should return 1 day when to_day is blank" do
    free_day = FreeDay.new(
      name: "One Day", 
      from_day: Date.new(2025, 12, 25)
    )
    assert_equal 1.day, free_day.duration
  end

  test "duration should calculate correct number of days in range" do
    free_day = FreeDay.new(
      name: "Three Days", 
      from_day: Date.new(2025, 12, 24), 
      to_day: Date.new(2025, 12, 26)
    )
    assert_equal 3.days, free_day.duration
  end

  test "intersects? should return true for exact date match when to_day is blank" do
    free_day = FreeDay.new(
      name: "One Day", 
      from_day: Date.new(2025, 12, 25)
    )
    assert free_day.intersects?(Date.new(2025, 12, 25))
  end

  test "intersects? should return false for different date when to_day is blank" do
    free_day = FreeDay.new(
      name: "One Day", 
      from_day: Date.new(2025, 12, 25)
    )
    refute free_day.intersects?(Date.new(2025, 12, 24))
  end

  test "intersects? should return true for date within range" do
    free_day = FreeDay.new(
      name: "Three Days", 
      from_day: Date.new(2025, 12, 24), 
      to_day: Date.new(2025, 12, 26)
    )
    assert free_day.intersects?(Date.new(2025, 12, 25))
  end

  test "intersects? should return true for date at start of range" do
    free_day = FreeDay.new(
      name: "Three Days", 
      from_day: Date.new(2025, 12, 24), 
      to_day: Date.new(2025, 12, 26)
    )
    assert free_day.intersects?(Date.new(2025, 12, 24))
  end

  test "intersects? should return true for date at end of range" do
    free_day = FreeDay.new(
      name: "Three Days", 
      from_day: Date.new(2025, 12, 24), 
      to_day: Date.new(2025, 12, 26)
    )
    assert free_day.intersects?(Date.new(2025, 12, 26))
  end

  test "intersects? should return false for date before range" do
    free_day = FreeDay.new(
      name: "Three Days", 
      from_day: Date.new(2025, 12, 24), 
      to_day: Date.new(2025, 12, 26)
    )
    refute free_day.intersects?(Date.new(2025, 12, 23))
  end

  test "intersects? should return false for date after range" do
    free_day = FreeDay.new(
      name: "Three Days", 
      from_day: Date.new(2025, 12, 24), 
      to_day: Date.new(2025, 12, 26)
    )
    refute free_day.intersects?(Date.new(2025, 12, 27))
  end
end
