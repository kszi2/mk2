# frozen_string_literal: true

class BreadcrumbsComponent::LinkComponent < ViewComponent::Base
  def initialize(url:)
    @url = url
  end
end
