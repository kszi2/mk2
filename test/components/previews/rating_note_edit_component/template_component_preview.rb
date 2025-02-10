# frozen_string_literal: true

class RatingNoteEditComponent::TemplateComponentPreview < ViewComponent::Preview
  def default
    render(RatingNoteEditComponent::TemplateComponent.new)
  end
end
