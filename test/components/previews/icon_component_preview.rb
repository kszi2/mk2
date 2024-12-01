# frozen_string_literal: true

class IconComponentPreview < ViewComponent::Preview
  def default
    render(IconComponent.new(name: "name"))
  end
end
