# frozen_string_literal: true

class TabviewComponentPreview < ViewComponent::Preview
  def default
    render(TabviewComponent.new)
  end
end
