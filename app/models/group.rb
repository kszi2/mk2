class Group < ApplicationRecord
  belongs_to :course
  has_and_belongs_to_many :students

  validates :name, presence: true, uniqueness: { scope: :course_id }
end
