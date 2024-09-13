class RatingPoint < ApplicationRecord
  belongs_to :coursework
  has_many :marked_points

  validates :name, presence: true, uniqueness: { scope: :coursework_id }
  validates :available_points, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def criterion?
    available_points == 0
  end
end
