class Coursework < ApplicationRecord
  extend PublicFindable["cW"]

  belongs_to :course
  belongs_to :for_type, class_name: 'CourseType'
  has_many :rating_points

  scope :for_group, ->(group) {
    order(:name)
      .where(active: true)
      .where(course_id: group.course_id)
      .where(for_type_id: group.course_type_id)
  }

  validates :name, presence: true, uniqueness: { scope: :course_id }, length: { in: 2..1024 }
  validates :active, inclusion: { in: [true, false] }
  validates :for_type_id, presence: true

  def for_type_pid
    for_type&.public_id
  end

  def criteria_count
    rating_points.count { |rp| rp.criterion? }
  end

  def total_points
    # criterion points don't matter in total points, conveniently, they have 0
    # as their available_points
    rating_points.sum(&:available_points)
  end
end
