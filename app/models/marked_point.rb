class MarkedPoint < ApplicationRecord
  belongs_to :submission
  belongs_to :rating_point
  has_many :marking_notes

  def marked_for
    rating_point.available_points - total_points_cost
  end

  def total_points_cost
    return 0 if marking_notes.empty?
    marking_notes.filter_map { |n| n.points_cost unless n.fixed }.inject(:+) || 0
  end
end
