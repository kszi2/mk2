# frozen_string_literal: true

class Inputs::TextareaComponent < Inputs::FormComponent
  renders_one :label

  def initialize(name:, value:, enabled:, id:, **options)
    @name = name
    @value = value
    @enabled = enabled
    @id = id || object_id
    @classes = options[:class]
    @data = options[:data] || {}
  end

  def true_value
    @value || ""
  end
end
