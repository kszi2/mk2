# frozen_string_literal: true

class PreviewRatingsStyleComponentPreview < ViewComponent::Preview
  def default
    render(PreviewRatingsStyleComponent.new(rating_style: RatingStyle.first))
  end
end
