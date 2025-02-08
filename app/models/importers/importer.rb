# frozen_string_literal: true

class Importers::Importer
  attr_reader :file

  def initialize(file)
    @file = file
  end

  # Parses and returns a list of Student objects
  # They are not saved.
  def students
  end
end
