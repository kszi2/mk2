# frozen_string_literal: true

class CodeEditorComponent < ViewComponent::Base
  include ComponentHelper

  renders_one :label

  def initialize(id:, form_name:, lang:, value: nil, editable: true)
    @form_name = form_name
    @lang = lang
    @id = id
    @editable = editable
    @value = value
  end
end
