# frozen_string_literal: true

class NavbarComponent::NavbarEntryComponent < ViewComponent::Base
  attr_reader :name, :href

  def initialize(name:, href:, link_type: :navbar)
    @name = name
    @href = href
    @link_type = link_type
  end

  def link_type_class
    case @link_type
    in :navbar
      "hidden md:flex"
    else # :dropdown
      "md:hidden flex"
    end
  end

  def to_dropdown
    NavbarComponent::NavbarEntryComponent.new(name: @name, href: @href, link_type: :dropdown)
  end
end
