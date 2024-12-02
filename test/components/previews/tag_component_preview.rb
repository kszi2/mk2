# frozen_string_literal: true

class TagComponentPreview < ViewComponent::Preview
  # @param text text
  # @param closable toggle
  # @param style select { choices: [default, warning, danger] }
  def default(text: "text", closable: false, style: :default)
    render(TagComponent.new(text: text, closable: closable, style: style))
  end
end
