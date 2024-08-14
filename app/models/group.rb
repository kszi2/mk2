class Group < ApplicationRecord
  belongs_to :course

  validates :name, presence: true, uniqueness: { scope: :course_id }
end
