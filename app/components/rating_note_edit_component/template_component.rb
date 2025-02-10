# frozen_string_literal: true

class RatingNoteEditComponent::TemplateComponent < ViewComponent::Base
  def initialize(template:, holder_id:)
    @template = template
    @holder_id = holder_id
  end
end
