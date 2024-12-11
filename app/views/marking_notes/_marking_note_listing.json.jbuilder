json.extract! marking_note, :id, :public_id, :points_cost, :reason
json.fixed !!marking_note.fixed
json.url course_group_submission_marked_point_marking_note_url(course, group, marking_note.marked_point.submission, marking_note.marked_point, marking_note, format: :json)
