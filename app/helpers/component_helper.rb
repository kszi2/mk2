# frozen_string_literal: true

module ComponentHelper
  def entity_name(obj)
    if obj.respond_to?(:name)
      obj.name
    elsif obj.respond_to?(:render_as)
      obj.render_as
    end
  end

  ButtonComponent::SupportedTypes.each do |type|
    self.define_method("#{type}_button_tag") do |text, href = nil, options = {}|
      render ButtonComponent.new(type: type,
                                 text: text,
                                 href: href,
                                 size: options[:size] || :normal,
                                 data: options[:data] || {})
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

  def submit_button_tag(text = "Save", href = nil, options = {})
    primary_button_tag(text, href, options)
  end

  def mk_form_for(*args)
    render MkFormComponent.new(*args) do |f|
      yield f
    end
  end

  def mk_show_for(*args)
    render ShowShellComponent.new(objects: args) do |s|
      yield s
    end
  end

  def mk_edit_for(*args, **options)
    render EditShellComponent.new(objects: args, **options) do |f|
      yield f
    end
  end

  def mk_new_for(*args)
    render NewShellComponent.new(objects: args) do |f|
      yield f
    end
  end
end
