# frozen_string_literal: true

class Shells::ShowShellComponent::PropertyComponent < ViewComponent::Base
  def initialize(name:, value:)
    @name = name
    @value = value
    @value = @value.name if @value.respond_to?(:name)
  end

  private

  def button_style
    'text-text-normal bg-surface-raised border-surface-border' +
      ' hover:bg-surface-default active:bg-surface-lowered'
  end
end
