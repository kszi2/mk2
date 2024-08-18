module ApplicationHelper
  include ActionView::Helpers::TagHelper

  def errorable_input(object, field)
    content_tag :div, class: 'flex flex-col gap-1' do
      errors = content_tag :div, class: 'flex flex-col text-wa-danger-fill-loud' do
        object.errors[field].collect do |error|
          content_tag :div, error.upcase_first
        end.join.html_safe
      end
      yield + errors
    end
  end

  %w[text number date].each do |type|
    ApplicationHelper.define_method "wa_#{type}_tag".to_sym do |object, field|
      wa_input_tag object, field, type
    end
  end

  def wa_submit_tag(text = "Save")
    content_tag :"wa-button", text, type: 'submit', value: text, variant: 'brand'
  end

  def wa_input_tag(object, field, type)
    errorable_input object, field do
      # noinspection RubyArgCount field_name needs only one param here
      raw_wa_input_tag field_name(field), type, field.to_s.humanize, object.send(field)
    end
  end

  def raw_wa_input_tag(name, type, label, value = nil)
    tag.send :'wa-input',
             name: name,
             type: type,
             value: value,
             label: label
  end
end

class ActionView::Helpers::FormBuilder
  include ApplicationHelper

  %i[wa_text wa_date wa_number].each do |type|
    self.define_method type do |field|
      self.send("#{type.to_s}_tag".to_sym, @object, field)
    end
  end

  def wa_submit(text = "Save")
    wa_submit_tag text
  end
end
