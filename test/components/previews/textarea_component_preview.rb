# frozen_string_literal: true

class TextareaComponentPreview < ViewComponent::Preview
  def default
    render(TextareaComponent.new(name: "name", value: "value", enabled: "enabled", id: "id", size: "size"))
  end
end
