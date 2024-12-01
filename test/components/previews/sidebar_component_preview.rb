# frozen_string_literal: true

class SidebarComponentPreview < ViewComponent::Preview
  # @param title text
  # @param dismissible toggle
  def default(title: "title", dismissible: true)
    render(SidebarComponent.new(title: title, dismissible: dismissible).with_content("Text"))
  end
end
