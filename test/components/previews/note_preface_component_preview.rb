# frozen_string_literal: true

class NotePrefaceComponentPreview < ViewComponent::Preview
  def default
    render(NotePrefaceComponent.new(fixed: "fixed", points_cost: "points_cost", fatal: "fatal"))
  end
end
