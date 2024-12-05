# frozen_string_literal: true

class PreviewRatingsStyleComponent < ViewComponent::Base
  def initialize(rating_style:)
    @rating_style = rating_style
    PreviewRatingsStyleComponent.unscope_all do
      @submission = Submission
                      .strict_loading
                      .unscoped
                      .eager_load(marked_points: [:rating_point, :marking_notes])
                      .where(id: -1)
                      .first!
    end
  rescue
    @submission = PreviewRatingsStyleComponent.create_data
  end

  def self.create_data
    Submission.transaction do
      unscope_all do
        course = Course.create!(id: -1, name: "Course")
        ct = CourseType.create!(id: -1, course: course, name: "Course Type 1")
        course.course_types << ct
        submission = Submission.create!(
          id: -1,
          coursework: Coursework.create!(id: -1,
                                         name: "Coursework",
                                         course: course,
                                         for_type: ct),
          student: Student.create!(
            id: -1,
            name: "Student",
            neptun: "FASZXD",),
          )
        marked = MarkedPoint.create!(
          id: -1,
          submission: submission,
          rating_point: RatingPoint.create!(id: -1,
                                            name: "Rating reason",
                                            coursework: submission.coursework,
                                            available_points: 1),
          )
        MarkedPoint.create!(
          id: -2,
          submission: submission,
          rating_point: RatingPoint.unscoped.create!(id: -2,
                                                     name: "Rating reason 2",
                                                     coursework: submission.coursework,
                                                     available_points: 1),
          )
        MarkedPoint.create!(
          id: -3,
          submission: submission,
          rating_point: RatingPoint.create!(id: -3,
                                            name: "Rating criterion",
                                            coursework: submission.coursework,
                                            available_points: 0),
          )
        MarkedPoint.create!(
          id: -4,
          submission: submission,
          rating_point: RatingPoint.create!(id: -4,
                                            name: "Rating criterion 2",
                                            coursework: submission.coursework,
                                            available_points: 0),
          )
        marked.marking_notes << MarkingNote.create!(
          id: -1,
          marked_point: marked,
          points_cost: -1,
          reason: "Valami random ok",
          fixed: false)
        marked.marking_notes << MarkingNote.create!(
          id: -2,
          marked_point: marked,
          points_cost: 0,
          reason: "Valami random megjegyzés",
          fixed: false)
        submission.marked_points << marked
        submission.save!
        submission
      end
    end
  end

  def render_text
    template = nil
    @rating_style.erb_source.open do |file|
      template = File.read(file)
    end
    raise ArgumentError.new("cannot read attached file for style: #{@rating_style.name}") \
      unless template

    erb = ERB.new(template, trim_mode: "%-")

    render = RenderEncapsulation.new(@submission)
    PreviewRatingsStyleComponent.unscope_all do
      erb.result(render.get_binding)
    end
  end

  def self.unscope_all
    # This is probably a horrible hack, the preview needs a valid object in the db, but
    # we don't want to let anyone see this object outside the preview page, so
    # we have it as a negative id, and have ApplicationRecord auto-filter for
    # id > 0
    Submission.unscoped do
      RatingPoint.unscoped do
        MarkedPoint.unscoped do
          MarkingNote.unscoped do
            yield
          end
        end
      end
    end
  end

  private

  class RenderEncapsulation
    # provide the helpers
    include SubmissionsHelper
    include MarkingNotesHelper

    attr_reader :submission

    def initialize(submission)
      @submission = submission
    end

    def get_binding
      binding
    end
  end
end
