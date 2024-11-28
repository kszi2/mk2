# frozen_string_literal: true

class RatingNoteEditComponentPreview < ViewComponent::Preview
  # @param reason text
  # @param points number
  # @param fixed toggle
  # @param fatal toggle
  def default(reason: "", points: 0, fixed: false, fatal: false)
    render(RatingNoteEditComponent.new(
      note: MarkingNote.new(
        id: 1,
        marked_point: MarkedPoint.new(
          submission: Submission.new(
            id: 1,
            coursework: Coursework.new(id: 1, course: Course.new(id: 1)),
            student: Student.new(
              id: 1,
              groups: [Group.new(id: 1, name: "Group 1", course_id: 1)]),
            ),
          rating_point: RatingPoint.new(available_points: fatal ? 0 : 1),
          ),
        points_cost: points,
        reason: reason,
        fixed: fixed,)
    ))
  end
end
