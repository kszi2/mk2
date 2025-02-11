# frozen_string_literal: true

class RatingNoteEditComponent < ViewComponent::Base
  include ComponentHelper
  include Turbo::FramesHelper
  include UrlHelper

  def initialize(note:, url: nil, method: :put)
    @url = url
    @method = method || :put
    @note = note
    @course = @note.marked_point.submission.coursework.course
    @preface_comp = NotePrefaceComponent.new(id: @note.id,
                                             text: @note.reason || "New note",
                                             fixed: @note.fixed,
                                             points_cost: @note.points_cost,
                                             fatal: @note.criterion?,
                                             active: false)
  end

  private

  def update_method = @method

  def update_url
    return @url if @url.present?

    mp = @note.marked_point
    subm = mp.submission
    cw = subm.coursework
    course = cw.course
    group = subm.student.groups.where(course: course).first
    url_for([course, group, subm, mp, @note])
  rescue _
    logger.error("Unknown update path for #{@note}")
    "#"
  end
end
