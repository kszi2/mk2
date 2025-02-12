class MarkingNote < ApplicationRecord
  extend PublicFindable["M"]

  belongs_to :marked_point

  validates :points_cost, presence: true, numericality: true
  validates :fixed, inclusion: { in: [true, false] }, allow_blank: true

  def effective_cost
    return 0 if fixed
    points_cost
  end

  def criterion?
    marked_point.criterion?
  end

  def name
    "Note"
  end
end
