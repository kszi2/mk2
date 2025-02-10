# frozen_string_literal: true

class Shells::EditShellComponent < Shells::ShellComponent
  include ComponentHelper

  renders_one :form, ->(&block) do
    MkFormComponent.new(*@full_objects, method: option(:method) || :put, &block)
  end

  def initialize(objects:, **kwargs)
    super(objects: objects, **kwargs)
  end
end
