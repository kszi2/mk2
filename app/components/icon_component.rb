# frozen_string_literal: true

class IconComponent < ViewComponent::Base
  def initialize(name:, classes: "")
    @name = name
    @classes = classes
  end
end
