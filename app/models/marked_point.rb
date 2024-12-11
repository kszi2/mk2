class MarkedPoint < ApplicationRecord
  extend PublicFindable["mP"]

  belongs_to :submission
  belongs_to :rating_point
  has_many :marking_notes, dependent: :delete_all

  scope :criteria_points, ->(category = nil) do
    basic = eager_load(:marking_notes, :rating_point)
              .order("rating_points.ordering")
              .where(rating_points: { available_points: 0 })
    basic = basic.where(rating_points: { category: category }) if category
    basic
  end

  scope :standard_points, ->(category = nil) do
    basic = eager_load(:marking_notes, :rating_point)
              .order("rating_points.ordering")
              .where.not(rating_points: { available_points: 0 })
    basic = basic.where(rating_points: { category: category }) if category
    basic
  end

  def point_name
    rating_point.name
  end

  def available_points
    rating_point.available_points
  end

  def marked_for
    available_points - total_points_cost
  end

  def criterion?
    rating_point.criterion?
  end

  def failed_criterion?
    return false unless rating_point.criterion?
    total_points_cost != 0
  end

  def total_points_cost
    return 0 if marking_notes.empty?
    marking_notes.filter_map { |n| n.points_cost unless n.fixed }.inject(:+) || 0
  end
end
