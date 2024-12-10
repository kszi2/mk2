# frozen_string_literal: true

class Inputs::SelectComponent < Inputs::FormComponent
  include Sizable

  renders_one :label
  renders_many :options, SelectOptionComponent

  def initialize(name:, value:, enabled:, id: nil, size: :normal, data: {})
    @name = name
    @value = value
    @enabled = enabled
    @size = size
    @id = id || ("obj_" + object_id.to_s)
    @data = data
  end
end
