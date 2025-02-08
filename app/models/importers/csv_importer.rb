# frozen_string_literal: true

class Importers::CSVImporter < Importers::Importer
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
end
