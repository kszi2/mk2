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
      "group-hover/x:text-danger-fill-normal"
    in :warning
      "group-hover/x:text-danger-fill-normal"
    in :danger
      "group-hover/x:text-neutral-fill-quiet"
    end
  end

  # Classes for the colors of the main tag body
  def root_color_classes
    case @style
    in :default
      "border-neutral-border-normal bg-neutral-fill-normal"
    in :warning
      "border-warning-border-normal bg-warning-fill-normal"
    in :danger
      "border-danger-border-loud bg-danger-fill-loud"
    end
  end
end
