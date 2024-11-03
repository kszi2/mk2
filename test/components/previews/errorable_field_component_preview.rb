# frozen_string_literal: true

class ErrorableFieldComponentPreview < ViewComponent::Preview
  def default
    render(ErrorableFieldComponent.new(object: "object", field: "field"))
  end
end
