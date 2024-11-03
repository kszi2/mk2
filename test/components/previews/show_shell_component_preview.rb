# frozen_string_literal: true

class ShowShellComponentPreview < ViewComponent::Preview
  def default
    render(ShowShellComponent.new(objects: "objects"))
  end
end
