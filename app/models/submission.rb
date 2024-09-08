class Submission < ApplicationRecord
  belongs_to :student
  belongs_to :coursework
  has_many :rating_points, through: :coursework
  has_many :marked_points

  def total_points
    coursework.total_points
  end

  def marked_for
    total_points - marked_points.map(&:total_points_cost).inject(:+)
  end
end
