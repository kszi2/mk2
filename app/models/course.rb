class Course < ApplicationRecord
  has_many :templates
  has_many :groups
  has_many :courses
  has_many :course_types
  has_many :courseworks
  belongs_to :default_rating_style, class_name: RatingStyle.name, inverse_of: :defaulted_in_courses, optional: true

  validates :name, presence: true, uniqueness: true, length: { in: 2..32 }
end
