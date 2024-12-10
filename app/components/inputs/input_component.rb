# frozen_string_literal: true

class Inputs::InputComponent < Inputs::FormComponent
  include Sizable

  SupportedTypes = %i[text email date time datetime tel password number url]

  renders_one :label

  def initialize(type:, name:, value:, enabled:, id: nil, size: :normal)
    if type.is_a?(Hash)
      raise ArgumentError.new("invalid type for InputComponent: #{type}") unless type.has_key?(:number)

      @type = :number
      @step = type[:number]
    else
      @type = type
      @step = 1 # only used by number atm
    end
    @name = name
    @value = value
    @enabled = enabled
    @size = size
    @id = id || object_id
  end

  def active_step
    @step if @type == :number
  end

  def effective_type
    return 'datetime-local' if @type == :datetime
    @type.to_s
  end
end
