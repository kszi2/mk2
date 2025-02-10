# frozen_string_literal: true

class RatingNoteEditComponent::TemplatesComponent < ViewComponent::Base
  include ComponentHelper

  def initialize(sibling:, course_id:, templates:)
    @sibling = sibling
    @templates = templates
    @course_id = course_id
  end

  def sibling_outlet
    "turbo-frame##{@sibling} > div:has(textarea[name='marking_note[reason]'])"
  end

  #def render? = !@templates.empty?
end
