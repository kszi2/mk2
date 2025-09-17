# frozen_string_literal: true

class FlashComponent < ViewComponent::Base
  renders_one :body
  renders_one :icon

  def initialize(type:, title:, body_text: nil)
    @type = type
    @title = title
    @body_text = body_text
  end

  private

  def effective_body
    if body?
      logger.warn("Flash given both body an body_text, using body") if @body_text.present?
      return body
    end
    content_tag :p, @body_text
  end

  def effective_icon
    return icon if icon?
    case @type
    when :notice
      render IconComponent.new(name: "square-exclamation")
    when :success
      render IconComponent.new(name: "circle-check")
    when :alert
      render IconComponent.new(name: "hexagon-xmark")
    else
      invalid_type
    end
  end

  def border_color
    case @type
    when :notice
      "border-neutral-border-normal hover:border-neutral-border-loud"
    when :success
      "border-success-border-quiet hover:border-success-border-normal"
    when :alert
      "border-danger-border-quiet hover:border-danger-border-normal"
    else
      invalid_type
    end
  end

  def bg_color
    case @type
    when :notice
      "bg-neutral-fill-normal hover:bg-neutral-fill-loud"
    when :success
      "bg-success-fill-quiet hover:bg-success-fill-normal"
    when :alert
      "bg-danger-fill-quiet hover:bg-danger-fill-normal"
    else
      invalid_type
    end
  end

  def text_color
    case @type
    when :notice
      "text-neutral-on-normal hover:text-neutral-on-loud"
    when :success
      "text-success-on-quiet hover:text-success-on-normal"
    when :alert
      "text-danger-on-quiet hover:text-danger-on-normal"
    else
      invalid_type
    end
  end

  def invalid_type = raise ArgumentError, "type given is invalid: #{@type}"
end
