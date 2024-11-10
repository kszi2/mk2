# frozen_string_literal: true

class MkFormComponent < ViewComponent::Base
  include ComponentHelper

  renders_many :fields, ->(type, field, options = {}, &block) do
    obj = @true_object
    render ErrorableFieldComponent.new(object: @true_object, field: field) do |ec|
      ec.proper_field(type,
                      name: field_name(obj.class.name.underscore, field),
                      value: obj.send(field),
                      enabled: options[:enabled] || true,
                      id: field_id(obj, field)) do |input|
        if block.nil?
          input.with_label { field.to_s.humanize }
        else
          block.call(input)
        end
      end
    end
  end

  renders_one :cancel

  def initialize(*object, inline: true)
    @inline = inline
    @object = object
    if object.is_a? Array
      @true_object = object.last
      @parent_objects = object[0..-2]
    else
      @true_object = object
      @parent_objects = []
    end
  end

  def data_turbo_location
    return {} if @inline
    { turbo_frame: "_top" }
  end

  def back_url
    # Return object's path if it is already persisted, otherwise parent's path
    # and fallback to root if there are no parents
    return url_for(@object) unless @true_object.new_record?
    return url_for(controller: @true_object.class.name.underscore.pluralize, action: :index) if @parent_objects.blank?
    url_for(@parent_objects)
  end
end
