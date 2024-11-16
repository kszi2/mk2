# frozen_string_literal: true

class Shells::ShowShellComponent < Shells::ShellComponent
  renders_one :extras
  renders_many :properties, ->(field, name: nil, value: nil) do
    PropertyComponent.new(name: name || field.to_s.humanize, value: value || @head_object.send(field))
  end
  renders_many :customs, CustomPropertyComponent

  def initialize(objects:)
    super(objects: objects)
  end
end
