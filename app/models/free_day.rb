class FreeDay < ApplicationRecord
  extend PublicFindable["F"]

  validates :name, presence: true, uniqueness: { scope: :from_day, case_sensitive: false }
  validates :from_day, presence: true
  validates :to_day, comparison: { greater_than_or_equal_to: :from_day }, allow_nil: true

  def duration
    return 1.day if to_day.blank?
    # difference of two dates is the number of "nights" between them, if we want
    # inclusive days, we need to add 1 to it
    nights = (to_day - from_day).to_i
    (nights + 1).days
  end

  def intersects?(date)
    return date == from_day if to_day.blank?
    date.between?(from_day, to_day)
  end
end
