# frozen_string_literal: true

class ReportOpenerComponent < ViewComponent::Base
  include ComponentHelper

  def initialize(submission_url:, rating_styles:, default:)
    @submission = submission_url
    @rating_styles = rating_styles
    @default = default
  end

  def default_id
    return if @default.blank?
    @default.public_id
  end
end
