class MarkingNote < ApplicationRecord
  belongs_to :marked_point

  validates :points_cost, presence: true, numericality: { only_integer: true }
  validates :fixed, presence: true, inclusion: { in: [true, false] }, allow_nil: true
end
