# frozen_string_literal: true

class NewShellComponentPreview < ViewComponent::Preview
  def default
    render(NewShellComponent.new(objects: "objects"))
  end
end
