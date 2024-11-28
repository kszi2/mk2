# frozen_string_literal: true

class RatingNoteComponent < ViewComponent::Base
  include ComponentHelper
  include Turbo::FramesHelper
  include Rails.application.routes.url_helpers

  def initialize(note:)
    @note = note
    @preface_comp = NotePrefaceComponent.new(text: @note.reason,
                                             fixed: @note.fixed,
                                             points_cost: @note.points_cost,
                                             fatal: @note.criterion?)
  end

  def note_reason
    return "¯\\_(ツ)_/¯" if @note.reason.blank?
    @note.reason
  end

  def fix_icon_classes
    return "fa-xmark-to-slot group-hover/button:text-wa-danger-fill-loud" \
      if @note.fixed?
    "fa-check-to-slot group-hover/button:text-wa-success-fill-loud"
  end

  def edit_url
    mp = @note.marked_point
    subm = mp.submission
    cw = subm.coursework
    course = cw.course
    group = subm.student.groups.where(course_id: course.id).first
    url_for([:edit, course, group, subm, mp, @note])
  end
end
