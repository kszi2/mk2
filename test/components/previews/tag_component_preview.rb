# frozen_string_literal: true

class TagComponentPreview < ViewComponent::Preview
  # @param text text
  # @param closable toggle
  def default(text: "text", closable: false)
    render(TagComponent.new(text: text, closable: closable))
  end
end
