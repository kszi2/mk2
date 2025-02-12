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
      "border-wa-neutral-border-normal hover:border-wa-neutral-border-loud"
    when :success
      "border-wa-success-border-quiet hover:border-wa-success-border-normal"
    when :alert
      "border-wa-danger-border-quiet hover:border-wa-danger-border-normal"
    else
      invalid_type
    end
  end

  def bg_color
    case @type
    when :notice
      "bg-wa-neutral-fill-normal hover:bg-wa-neutral-fill-loud"
    when :success
      "bg-wa-success-fill-quiet hover:bg-wa-success-fill-normal"
    when :alert
      "bg-wa-danger-fill-quiet hover:bg-wa-danger-fill-normal"
    else
      invalid_type
    end
  end

  def text_color
    case @type
    when :notice
      "text-wa-neutral-on-normal hover:text-wa-neutral-on-loud"
    when :success
      "text-wa-success-on-quiet hover:text-wa-success-on-normal"
    when :alert
      "text-wa-danger-on-quiet hover:text-wa-danger-on-normal"
    else
      invalid_type
    end
  end

  def invalid_type = raise ArgumentError, "type given is invalid: #{@type}"
end
