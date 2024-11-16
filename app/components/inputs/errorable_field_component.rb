# frozen_string_literal: true

class Inputs::ErrorableFieldComponent < ViewComponent::Base
  include Inputs

  renders_one :form_field, types: {
    input: InputComponent,
    select: SelectComponent,
    text: TextareaComponent
  }

  def proper_field(type, **kwargs, &block)
    case type
    when *InputComponent::SupportedTypes
      with_form_field_input(type: type, **kwargs, &block)
    when :select
      with_form_field_select(**kwargs, &block)
    when :textarea
      with_form_field_text(**kwargs, &block)
    else
      raise ArgumentError, "BAD: #{type}"
    end
  end

  def initialize(object:, field:)
    @object = object
    @field = field
  end

  def have_errors?
    @object.errors[@field].any?
  end

  def errors
    @object.errors[@field].map { |e| e.upcase_first }
  end

  def before_render
    if form_field?
      form_field.errored = have_errors?
    end
  end
end
