# frozen_string_literal: true

class ShowShellComponent < ShellComponent
  renders_one :extras
  renders_many :properties, ->(field, name: nil) do
    PropertyComponent.new(name: name || field.to_s.humanize, value: @head_object.send(field))
  end

  def initialize(objects:)
    super(objects: objects)
  end
end
