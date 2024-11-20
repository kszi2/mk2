# frozen_string_literal: true

class DataTableComponent::FilterComponent < ViewComponent::Base
  include Turbo::FramesHelper
  include Inputs
  include ComponentHelper

  def initialize(controller:, field:, name: nil, current_filters: {})
    @controller = controller
    @field = field
    @name = name || field.to_s.humanize
    @current = current_filters
  end

  def before_render
    @clear_url = url_for(controller: @controller, action: :index)
  end

  def current_filter
    @current.to_json
  end
end
