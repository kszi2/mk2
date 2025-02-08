# frozen_string_literal: true

class Importers::JPortaHTMLImporter < Importers::Importer
  def students
    students = []

    doc = Nokogiri::HTML(File.open(file.path))
    doc.xpath("//div[@id='members']//td[@data-sort-value]/@data-sort-value").each do |attr|
      name, neptun = attr.value.split /\|/
      students << Student.new(name: name, neptun: neptun.upcase)
    end

    students
  end
end
