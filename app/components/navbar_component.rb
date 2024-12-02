# frozen_string_literal: true

class NavbarComponent < ViewComponent::Base
  renders_many :entries, NavbarEntryComponent
end
