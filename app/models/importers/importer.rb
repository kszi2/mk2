# frozen_string_literal: true

class Importers::Importer
  attr_reader :file

  def initialize(file)
    @file = file
  end

  # Parses and returns a list of all Student objects
  # They are not saved.
  def students = []

  # Parses and returns a list of already existing Students and a list of (unsaved)
  # students that do not exist
  def exiting_students = [[], []]
end
