class Student < ApplicationRecord
  extend PublicFindable["S"]

  paginates_per 50

  has_and_belongs_to_many :groups
  has_many :courses, through: :groups
  has_many :submissions

  validates :name, presence: true, length: { in: 2..255 }
  validates :neptun,
            presence: true,
            length: { is: 6 },
            uniqueness: { case_sensitive: false },
            format: { with: /\A[a-zA-Z0-9]{6}\z/, message: "only allows 6 letters and numbers" }

  def results
    ret = {}
    submissions.each do |sub|
      ret[sub.coursework.course] = {} if ret[sub.coursework.course].nil?
      ret[sub.coursework.course][sub.group] = {} if ret[sub.coursework.course][sub.group].nil?

      ret[sub.coursework.course][sub.group][sub.coursework.name] = { total: sub.total_points, achieved: sub.marked_for }
    end

    ret
  end
end
