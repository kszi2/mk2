class Coursework < ApplicationRecord
  belongs_to :course

  validates :name, presence: true, uniqueness: { scope: :course_id }, length: { in: 2..32 }
  validates :active, inclusion: { in: [true, false] }, default: true
end
