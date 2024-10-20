class Coursework < ApplicationRecord
  belongs_to :course
  belongs_to :for_type, class_name: 'CourseType'
  has_many :rating_points

  validates :name, presence: true, uniqueness: { scope: :course_id }, length: { in: 2..1024 }
  validates :active, inclusion: { in: [true, false] }
  validates :for_type_id, presence: true

  def criteria_count
    rating_points.count { |rp| rp.criterion? }
  end

  def total_points
    # criterion points don't matter in total points, conveniently, they have 0
    # as their available_points
    rating_points.sum(&:available_points)
  end
end
