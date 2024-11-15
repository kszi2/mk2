# frozen_string_literal: true

class TabpageComponentPreview < ViewComponent::Preview
  def default
    render(TabpageComponent.new)
  end
end
