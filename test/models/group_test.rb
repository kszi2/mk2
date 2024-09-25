require "test_helper"

class GroupTest < ActiveSupport::TestCase
  test "group's next date is first date if currently before that" do
    first = Date.new(2024, 9, 2)
    g = make_group(first)
    assert_equal first, g.next_class_date(first - 1.week)
  end

  test "group's next date is the next date of class" do
    first = Date.new(2024, 9, 2)
    g = make_group(first)
    assert_equal first + 7.days, g.next_class_date(first + 1.day)
  end

  test "group's next date is nil if no more classes will be held" do
    first = Date.new(2024, 9, 2)
    g = make_group(first, repeat_times: 1, day_difference: 1)
    assert_nil g.next_class_date(first + 1.week)
  end

  test "group's dates' numericality is equal to repeat_times" do
    first = Date.new(2024, 9, 2)
    repeats = 14
    g = make_group(first, repeat_times: repeats)
    assert_equal repeats, g.dates_for_class.size
  end

  test "group's dates' starts with first class date" do
    first = Date.new(2024, 9, 2)
    g = make_group(first)
    assert_equal first, g.dates_for_class[0]
  end

  test "group's dates' difference between days is day_difference" do
    first = Date.new(2024, 9, 2)
    diff = 7
    g = make_group(first, day_difference: diff)
    dates = g.dates_for_class
    assert_equal diff, dates[1] - dates[0]
  end

  private

  def make_group(first, **kwargs)
    Group.new first_date: first,
              day_difference: 7,
              repeat_times: 14,
              **kwargs
  end
end
