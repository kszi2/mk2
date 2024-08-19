class Coursework < ApplicationRecord
  belongs_to :course
  belongs_to :for_type, class_name: 'CourseType'

  validates :name, presence: true, uniqueness: { scope: :course_id }, length: { in: 2..32 }
  validates :active, inclusion: { in: [true, false] }
  validates :for_type_id, presence: true
end
