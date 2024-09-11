require 'csv'

class Student < ApplicationRecord
  has_and_belongs_to_many :groups
  has_many :courses, through: :groups

  validates :name, presence: true, length: { in: 2..255 }
  validates :neptun,
            presence: true,
            length: { is: 6 },
            uniqueness: { case_sensitive: false },
            format: { with: /\A[a-zA-Z0-9]{6}\z/, message: "only allows 6 letters and numbers" }

  def Student.import(file)
    errors = []
    i = 1

    CSV.foreach(file, headers: true) do |row|
      current_row = i
      i = i + 1

      data = row.to_hash
      puts data
      data["neptun"].upcase!
      student = Student.create(data)
      next if student.valid?

      logger.warn "errors for: #{student.inspect}"
      errors << { index: current_row, errors: student.errors.messages }
    end

    errors
  end
end
