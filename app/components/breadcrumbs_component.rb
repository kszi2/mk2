# frozen_string_literal: true

class BreadcrumbsComponent < ViewComponent::Base
  def initialize(path:)
    @path = path
  end
end
