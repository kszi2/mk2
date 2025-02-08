# frozen_string_literal: true

require_relative './csv_importer'
require_relative './j_porta_html_importer'

class Importers::ImporterFactory
  def self.build_importer_by_heuristic(input_file)
    if input_file.path.ends_with?(".csv")
      Importers::CSVImporter.new(input_file)
    elsif input_file.path.ends_with?(".html") || input_file.path.ends_with?(".htm")
      html_importer(input_file)
    end
  end

  private

  def self.html_importer(file)
    doc = Nokogiri::HTML(File.open(file.path))
    t = doc.xpath("/html/head/title/text()").first

    if t.content.include? "JPORTA"
      Importers::JPortaHTMLImporter.new(file)
    end
  end
end
