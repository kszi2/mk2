class Student < ApplicationRecord
  extend PublicFindable["S"]

  paginates_per 50

  has_and_belongs_to_many :groups
  has_many :courses, through: :groups

  validates :name, presence: true, length: { in: 2..255 }
  validates :neptun,
            presence: true,
            length: { is: 6 },
            uniqueness: { case_sensitive: false },
            format: { with: /\A[a-zA-Z0-9]{6}\z/, message: "only allows 6 letters and numbers" }
end
