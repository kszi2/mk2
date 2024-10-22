class MarkingNote < ApplicationRecord
  belongs_to :marked_point

  validates :points_cost, presence: true, numericality: { only_integer: true }
  validates :fixed, inclusion: { in: [true, false] }, allow_nil: true

  def effective_cost
    return 0 if fixed
    points_cost
  end
end
