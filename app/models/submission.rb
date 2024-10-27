class Submission < ApplicationRecord
  belongs_to :student
  belongs_to :coursework
  has_many :rating_points, through: :coursework
  has_many :marked_points

  validates :student_id, presence: true
  validates :coursework_id, presence: true, uniqueness: { scope: :student_id, message: "Already submitted" }, on: :create

  def total_points
    coursework.total_points
  end

  def marked_for
    total_points - marked_points.map(&:total_points_cost).inject(:+)
  end
end
