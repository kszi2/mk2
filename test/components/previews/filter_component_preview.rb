# frozen_string_literal: true

class FilterComponentPreview < ViewComponent::Preview
  def default
    render(FilterComponent.new(field: "field"))
  end
end
