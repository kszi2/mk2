# frozen_string_literal: true

class Shells::ShowShellComponent::CustomPropertyComponent < ViewComponent::Base
  def initialize(name:)
    @name = name
  end
end
