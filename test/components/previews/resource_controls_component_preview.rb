# frozen_string_literal: true

class ResourceControlsComponentPreview < ViewComponent::Preview
  # @param edit url
  # @param back url
  def default(edit: "#", back: "#")
    render(ResourceControlsComponent.new(edit: edit, back: back))
  end
end
