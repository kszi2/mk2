class RatingPoint < ApplicationRecord
  belongs_to :coursework
  has_many :marked_points

  default_scope { order(:ordering) }

  validates :name, presence: true, uniqueness: { scope: :coursework_id }
  validates :ordering,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 },
            allow_nil: true
  validates :category, length: { in: 1..32 }, allow_nil: true
  validates :available_points, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def criterion?
    available_points == 0
  end
end
