# frozen_string_literal: true

class RatingNoteComponent < ViewComponent::Base
  with_collection_parameter :note

  include ComponentHelper
  include Turbo::FramesHelper
  include Rails.application.routes.url_helpers

  def initialize(note:)
    @note = note
    @preface_comp = NotePrefaceComponent.for(@note)
  end

  def self.toggle_icon_id(note)
    "toggle_icon_#{note.id}"
  end

  def toggle_icon_id
    RatingNoteComponent.toggle_icon_id(@note)
  end

  def note_reason
    return "¯\\_(ツ)_/¯" if @note.reason.blank?
    @note.reason
  end

  def toggle_url
    url_for([*parent_objects, @note, :toggle])
  rescue
    logger.error("Unknown toggle path for #{@note}")
    "#"
  end

  def self.toggle_icon_classes(note)
    return "fa-xmark-to-slot group-hover/button:text-wa-danger-fill-loud" \
      if note.fixed?
    "fa-check-to-slot group-hover/button:text-wa-success-fill-loud"
  end

  def toggle_icon_classes
    RatingNoteComponent.toggle_icon_classes(@note)
  end
  alias fix_icon_classes toggle_icon_classes

  def edit_url
    url_for([:edit, *parent_objects, @note])
  rescue
    logger.error("Unknown edit path for #{@note}")
    "#"
  end

  def destroy_url
    url_for([*parent_objects, @note])
  rescue
    logger.error("Unknown destroy path for #{@note}")
    "#"
  end

  private

  def parent_objects
    mp = @note.marked_point
    subm = mp.submission
    cw = subm.coursework
    course = cw.course
    group = subm.student.groups.where(course: course).first
    [course, group, subm, mp]
  end
end
