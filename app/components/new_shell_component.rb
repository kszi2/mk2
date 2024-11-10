# frozen_string_literal: true

class NewShellComponent < ShellComponent
  renders_one :form, ->(&block) do
    MkFormComponent.new(*@full_objects, inline: false, &block)
  end

  def initialize(objects:, **kwargs)
    super(objects: objects, **kwargs)
  end
end
