class CourseType < ApplicationRecord
  belongs_to :course
  has_many :groups

  validates :name, presence: true, uniqueness: { scope: :course_id }, length: { in: 2..32 }
  validates :course_id, presence: true

  def to_select_value
    [ id, name ]
  end
end
