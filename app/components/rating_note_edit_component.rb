# frozen_string_literal: true

class RatingNoteEditComponent < ViewComponent::Base
  include ComponentHelper
  include Turbo::FramesHelper
  include UrlHelper

  def initialize(note:)
    @note = note
    @preface_comp = NotePrefaceComponent.new(id: @note.id,
                                             text: @note.reason || "Szar",
                                             fixed: @note.fixed,
                                             points_cost: @note.points_cost,
                                             fatal: @note.criterion?,
                                             active: false)
  end

  def update_url
    mp = @note.marked_point
    subm = mp.submission
    cw = subm.coursework
    course = cw.course
    group = subm.student.groups.where(course_id: course.id).first
    url_for([course, group, subm, mp, @note])
  rescue _
    logger.error("Unknown update path for #{@note}")
    "#"
  end
end
