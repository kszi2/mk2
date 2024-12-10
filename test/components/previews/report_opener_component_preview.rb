# frozen_string_literal: true

class ReportOpenerComponentPreview < ViewComponent::Preview
  def default
    render(ReportOpenerComponent.new(submission_url: "submission"))
  end
end
