# frozen_string_literal: true

class TagComponent < ViewComponent::Base
  def initialize(text:, style: :default, closable: false)
    @text = text
    @closable = closable
    @style = style
  end

  def xhover_classes
    case @style
    in :default
      "group-hover/x:text-wa-danger-fill-normal"
    in :warning
      "group-hover/x:text-wa-danger-fill-normal"
    in :danger
      "group-hover/x:text-wa-neutral-fill-quiet"
    end
  end

  # Classes for the colors of the main tag body
  def root_color_classes
    case @style
    in :default
      "border-wa-neutral-border-normal bg-wa-neutral-fill-normal"
    in :warning
      "border-wa-warning-border-normal bg-wa-warning-fill-normal"
    in :danger
      "border-wa-danger-border-loud bg-wa-danger-fill-loud"
    end
  end
end
