# frozen_string_literal: true

class Inputs::FormComponent < ViewComponent::Base
  attr_accessor :errored

  def error_border_style
    if errored
      'border-danger-border-loud'
    else
      'border-surface-border'
    end
  end

  def error_text_style
    if errored
      'text-danger-border-loud'
    else
      'text-neutral-on-normal'
    end
  end
end
