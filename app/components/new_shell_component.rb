# frozen_string_literal: true

class NewShellComponent < ShellComponent
  renders_one :form, ->(&block) do
    MkFormComponent.new(*@full_objects, &block)
  end

  def initialize(objects:)
    super(objects: objects)
  end
end
