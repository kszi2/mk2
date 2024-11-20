# frozen_string_literal: true

class LoaderComponentPreview < ViewComponent::Preview
  def default
    render(LoaderComponent.new)
  end
end
