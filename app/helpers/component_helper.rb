# frozen_string_literal: true

module ComponentHelper
  ButtonComponent::SupportedTypes.each do |type|
    self.define_method("#{type}_button_tag") do |text, href = nil, options = {}|
      render ButtonComponent.new(type: type, text: text, href: href, size: options[:size] || :normal)
    end
  end

  InputComponent::SupportedTypes.each do |type|
    self.define_method("#{type}_input_tag") do |obj, field, options = {}|
      raise ArgumentError, "Given object #{obj} does not respond to #{field}" unless obj.respond_to?(field)
      render ErrorableFieldComponent.new(object: obj, field: field) do |ec|
        ec.with_form_field_input(type: type,
                                 name: field_name(obj.class.name.underscore, field),
                                 value: obj.send(field),
                                 enabled: options[:enabled] || true,
                                 id: field_id(obj, field)) do |input|
          input.with_label { field.to_s.humanize }
        end
      end
    end

    self.define_method("#{type}_raw_input_tag") do |name, value = nil, options = {}|
      render InputComponent.new(type: type,
                                name: name,
                                value: value,
                                enabled: options[:enabled] || true,
                                id: options[:id]) do |input|
        input.with_label { options[:label] }
      end
    end
  end

  def submit_button_tag(text = "Save")
    primary_button_tag(text)
  end

  def mk_form_for(*args, &block)
    form_for(*args, builder: MkFormBuilder, &block)
  end
end

class MkFormBuilder < ActionView::Helpers::FormBuilder
  include ComponentHelper

  InputComponent::SupportedTypes.each do |type|
    self.define_method("mk_#{type}") do |field|
      @template.send("#{type.to_s}_input_tag".to_sym, @object, field)
    end
  end

  def mk_submit(text = "Save")
    @template.submit_button_tag(text)
  end
end
