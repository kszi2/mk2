json.id @marking_note.public_id
json.extract! @marking_note, :points_cost, :reason, :created_at, :updated_at
json.fixed !!@marking_note.fixed
json.url course_group_submission_marked_point_marking_note_url(@course, @group, @submission, @marked_point, @marking_note, format: :json)

json.submission_url course_group_submission_url(@course, @group, @submission)
