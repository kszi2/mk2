# frozen_string_literal: true

class FormComponent < ViewComponent::Base
  attr_accessor :errored

  def error_border_style
    if errored
      'border-wa-danger-border-loud'
    else
      'border-wa-surface-border'
    end
  end

  def error_text_style
    if errored
      'text-wa-danger-border-loud'
    else
      'text-wa-neutral-on-normal'
    end
  end
end
