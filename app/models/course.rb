class Course < ApplicationRecord
  has_many :templates
  has_many :groups
  has_many :courses

  validates :name, presence: true, uniqueness: true, length: { in: 2..32 }
end
