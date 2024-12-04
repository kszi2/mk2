class RatingStyle < ApplicationRecord
  has_one_attached :erb_source

  validates :name, presence: true, length: 2..64, uniqueness: true
  # validates :erb_source, allow_blank: true

  def source_as_text
    data = nil
    erb_source.open do |file|
      data = File.read(file)
    end
    data
  end
end
