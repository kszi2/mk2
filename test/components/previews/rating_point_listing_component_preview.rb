# frozen_string_literal: true

class RatingPointListingComponentPreview < ViewComponent::Preview
  def default
    render(RatingPointListingComponent.new(rating_point: "rating_point"))
  end
end
