# frozen_string_literal: true

class DragManagerComponent < ViewComponent::Base
  include Turbo::FramesHelper

  def initialize(reorder_url:)
    @reorder_url = reorder_url
  end
end
