# frozen_string_literal: true

class PropertyComponentPreview < ViewComponent::Preview
  def default
    render(PropertyComponent.new(name: "name", value: "value"))
  end
end
