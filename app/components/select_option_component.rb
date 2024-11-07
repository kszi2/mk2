# frozen_string_literal: true

class SelectOptionComponent < ViewComponent::Base
  def initialize(value: nil, selected: false, current: nil)
    @value = value
    @selected = selected
    @selected = @value == current unless current.nil?
  end
end
