# frozen_string_literal: true

class MkFormComponent < ViewComponent::Base
  include ComponentHelper

  renders_many :fields, ->(type, field, options = {}) do
    render ErrorableFieldComponent.new(object: @true_object, field: field) do |ec|
      obj = @true_object
      ec.proper_field(type,
                      name: field_name(obj.class.name.underscore, field),
                      value: obj.send(field),
                      enabled: options[:enabled] || true,
                      id: field_id(obj, field)) do |input|
        input.with_label { field.to_s.humanize }
      end
    end
  end

  def initialize(*object)
    @object = object
    if object.is_a? Array
      @true_object = object.last
    else
      @true_object = object
    end
  end
end
