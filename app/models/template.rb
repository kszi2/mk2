class Template < ApplicationRecord
  extend PublicFindable["T"]

  belongs_to :course, optional: true

  validates :name, presence: true, length: { in: 2..64 }
  validates :data, presence: true
end
