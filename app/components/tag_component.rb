# frozen_string_literal: true

class TagComponent < ViewComponent::Base
  def initialize(text:, closable: false)
    @text = text
    @closable = closable
  end
end
