# frozen_string_literal: true

class CustomPropertyComponent < ViewComponent::Base
  def initialize(name:)
    @name = name
  end
end
