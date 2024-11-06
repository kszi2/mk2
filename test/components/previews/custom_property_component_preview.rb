# frozen_string_literal: true

class CustomPropertyComponentPreview < ViewComponent::Preview
  def default
    render(CustomPropertyComponent.new(name: "name"))
  end
end
