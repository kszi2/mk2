# frozen_string_literal: true

class CodeEditorComponentPreview < ViewComponent::Preview
  # @param lang text
  # @param editable toggle
  # @param label text
  def default(lang: "erb", editable: true, label: "Label")
    cec = CodeEditorComponent.new(form_name: "form_name", lang: lang, id: 'uniq_id', editable: editable)
    cec.with_label { label }
    render cec
  end
end
