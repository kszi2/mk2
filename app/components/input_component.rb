# frozen_string_literal: true

class InputComponent < FormComponent
  include Sizable

  SupportedTypes = %i[text email date time datetime tel password number url]

  renders_one :label

  def initialize(type:, name:, value:, enabled:, id: nil, size: :normal)
    puts "++++ #{type} #{name} #{value} #{id} #{size}"
    @type = type
    @name = name
    @value = value
    @enabled = enabled
    @size = size
    @id = id || object_id
  end

  def effective_type
    return 'datetime-local' if @type == :datetime
    @type.to_s
  end
end
