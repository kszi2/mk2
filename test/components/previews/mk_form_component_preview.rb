# frozen_string_literal: true

class MkFormComponentPreview < ViewComponent::Preview
  def default
    render(MkFormComponent.new(object: "object"))
  end
end
