class Course < ApplicationRecord
  has_many :templates, dependent: :nullify
  has_many :groups, dependent: :delete_all
  has_many :course_types, dependent: :delete_all
  has_many :courseworks, dependent: :delete_all

  validates :name, presence: true, uniqueness: true, length: { in: 2..32 }
end
