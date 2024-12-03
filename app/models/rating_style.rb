class RatingStyle < ApplicationRecord
  has_one_attached :erb_source

  validates :name, presence: true, length: 2..64, uniqueness: true
  # validates :erb_source, allow_blank: true
end
