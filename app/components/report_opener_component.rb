# frozen_string_literal: true

class ReportOpenerComponent < ViewComponent::Base
  include ComponentHelper

  def initialize(submission_url:, rating_styles:)
    @submission = submission_url
    @rating_styles = rating_styles
  end
end
