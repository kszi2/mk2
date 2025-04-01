class Submission < ApplicationRecord
  extend PublicFindable["sM"]

  belongs_to :student
  belongs_to :coursework
  belongs_to :group
  has_many :rating_points, through: :coursework
  has_many :marked_points, -> { joins(:rating_point).order("rating_points.ordering") }, dependent: :destroy

  validates :student_id, presence: true
  validates :group_id, presence: true
  validates :coursework_id, presence: true, uniqueness: { scope: [:student_id, :group_id], message: "Already submitted" }, on: :create

  def total_points
    coursework.total_points
  end

  def for_coursework
    coursework.name
  end

  def criteria_points(*args)
    marked_points.criteria_points(*args)
  end

  def standard_points(*args)
    marked_points.standard_points(*args)
  end

  def marked_for
    return 0 if marked_points.any?(&:failed_criterion?)
    total_points - marked_points.map(&:total_points_cost).inject(0, &:+)
  end

  def render_as
    return "" if coursework.nil? || student.nil?
    "#{coursework.name} (#{student.name})"
  end
end
