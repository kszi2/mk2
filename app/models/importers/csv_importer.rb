# frozen_string_literal: true

require 'csv'

class Importers::CsvImporter < Importers::Importer
  def students
    students = []

    CSV.foreach(file.path, headers: true) do |row|
      data = row.to_hash
      data.transform_keys! { |key| key.gsub(/\P{Print}/, '').downcase.to_sym }
      data[:neptun].upcase!
      students << Student.new(neptun: data[:neptun], name: data[:name])
    end

    students
  end

  def existing_students
    students = []
    not_found = []

    CSV.foreach(file.path, headers: true) do |row|
      data = row.to_hash
      data.transform_keys! { |key| key.gsub(/\P{Print}/, '').downcase.to_sym }
      data[:neptun].upcase!

      s = Student.find_by(neptun: data[:neptun], name: data[:name])
      if s
        students << s
      else
        not_found << Student.new(neptun: data[:neptun], name: data[:name])
      end
    end

    [students, not_found]
  end
end
