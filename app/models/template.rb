class Template < ApplicationRecord
  belongs_to :course, optional: true

  validates :name, presence: true, length: { in: 2..64 }
  validates :data, presence: true
end
