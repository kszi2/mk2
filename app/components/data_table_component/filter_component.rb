# frozen_string_literal: true

class DataTableComponent::FilterComponent < ViewComponent::Base
  include Turbo::FramesHelper
  include Inputs
  include ComponentHelper

  def initialize(controller:,
                 field:,
                 clear_url:,
                 filter_url:,
                 name: nil,
                 current_filters: {})
    @controller = controller
    @field = field
    @clear_url = clear_url
    @filter_url = filter_url
    @name = name || field.to_s.humanize
    @current = current_filters
  end

  def current_filter
    @current.to_json
  end
end
