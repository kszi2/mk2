# frozen_string_literal: true

class BreadcrumbsComponentPreview < ViewComponent::Preview
  DefaultParam = [ %w/first google.com/, %w/second duckduckgo.com / ]

  # @param path
  def default(path: DefaultParam)
    render(BreadcrumbsComponent.new(path: path))
  end
end
