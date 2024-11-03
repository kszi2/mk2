# frozen_string_literal: true

class PropertyComponent < ViewComponent::Base
  def initialize(name:, value:)
    @name = name
    @value = value
  end

  private

  def button_style
    'text-wa-text-normal bg-wa-surface-raised border-wa-surface-border' +
      ' hover:bg-wa-surface-default active:bg-wa-surface-lowered'
  end
end
