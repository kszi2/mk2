# frozen_string_literal: true

class SidebarComponent < ViewComponent::Base
  def initialize(title:, dismissible: false)
    @title = title
    @dismissible = dismissible
  end

  # CSS classes for the base dismiss layer
  # if dismissible, then completely see-through, otherwise, slightly opaque
  def base_classes
    if @dismissible
      "w-dvw"
    else
      "w-dvw bg-surface-lowered/50"
    end
  end

  def sidebar_classes
    "right-0 h-lvh w-[100lvw] md:w-[75lvw] lg:w-[50lvw] bg-surface-raised"
  end
end
