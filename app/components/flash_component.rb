# frozen_string_literal: true

class FlashComponent < ViewComponent::Base
  renders_one :body
  renders_one :icon

  def initialize(type:, title:, body_text: nil)
    @type = type
    @title = title
    @body_text = body_text
  end

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
    in :notice
      render IconComponent.new(name: "square-exclamation")
    in :success
      render IconComponent.new(name: "circle-check")
    in :alert
      render IconComponent.new(name: "hexagon-xmark")
    end
  end

  def border_color
    case @type
    in :notice
      "border-wa-neutral-border-normal hover:border-wa-neutral-border-loud"
    in :success
      "border-wa-success-border-quiet hover:border-wa-success-border-normal"
    in :alert
      "border-wa-danger-border-quiet hover:border-wa-danger-border-normal"
    end
  end

  def bg_color
    case @type
    in :notice
      "bg-wa-neutral-fill-normal hover:bg-wa-neutral-fill-loud"
    in :success
      "bg-wa-success-fill-quiet hover:bg-wa-success-fill-normal"
    in :alert
      "bg-wa-danger-fill-quiet hover:bg-wa-danger-fill-normal"
    end
  end

  def text_color
    case @type
    in :notice
      "text-wa-neutral-on-normal hover:text-wa-neutral-on-loud"
    in :success
      "text-wa-success-on-quiet hover:text-wa-success-on-normal"
    in :alert
      "text-wa-danger-on-quiet hover:text-wa-danger-on-normal"
    end
  end
end
