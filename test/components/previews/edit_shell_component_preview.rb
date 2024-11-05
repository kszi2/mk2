# frozen_string_literal: true

class EditShellComponentPreview < ViewComponent::Preview
  def default
    render(EditShellComponent.new(objects: "objects"))
  end
end
