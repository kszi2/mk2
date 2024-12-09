# frozen_string_literal: true

class DragManagerComponentPreview < ViewComponent::Preview
  def default
    render(DragManagerComponent.new)
  end
end
