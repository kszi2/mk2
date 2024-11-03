# frozen_string_literal: true

class LinkComponentPreview < ViewComponent::Preview
  # @param url
  # @param content
  def default(url: 'https://duckduckgo.com', content: 'Content')
    render(LinkComponent.new(url: url).with_content(content))
  end
end
