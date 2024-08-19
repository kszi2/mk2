class Course < ApplicationRecord
  has_many :templates
  has_many :groups
  has_many :courses
  has_many :course_types
  has_many :courseworks

  validates :name, presence: true, uniqueness: true, length: { in: 2..32 }
end
