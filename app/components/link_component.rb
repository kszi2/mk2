# frozen_string_literal: true

class LinkComponent < ViewComponent::Base
  def initialize(url:)
    @url = url
  end
end
