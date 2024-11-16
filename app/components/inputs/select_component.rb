# frozen_string_literal: true

class Inputs::SelectComponent < Inputs::FormComponent
  include Sizable

  renders_one :label
  renders_many :options, SelectOptionComponent

  def initialize(name:, value:, enabled:, id: nil, size: :normal)
    @name = name
    @value = value
    @enabled = enabled
    @size = size
    @id = id || object_id
  end
end
