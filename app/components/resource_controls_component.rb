# frozen_string_literal: true

class ResourceControlsComponent < ViewComponent::Base
  def initialize(edit:, back:)
    @edit = edit
    @back = back
  end
end
