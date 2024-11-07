class Submission < ApplicationRecord
  belongs_to :student
  belongs_to :coursework
  has_many :rating_points, through: :coursework
  has_many :marked_points, dependent: :destroy

  validates :student_id, presence: true
  validates :coursework_id, presence: true, uniqueness: { scope: :student_id, message: "Already submitted" }, on: :create

  def total_points
    coursework.total_points
  end

  def marked_for
    return 0 if marked_points.any?(&:failed_criterion?)
    total_points - marked_points.map(&:total_points_cost).inject(:+)
  end

  def render_as
    return "" if coursework.nil? || student.nil?
    "#{coursework.name} (#{student.name})"
  end
end
