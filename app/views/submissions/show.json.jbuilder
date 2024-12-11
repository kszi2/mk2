json.id @submission.public_id
json.extract! @submission, :total_points, :marked_for, :created_at, :updated_at
json.url course_group_submission_url(@course, @group, @submission, format: :json)

json.course_url course_url(@course, :json)
json.group_url course_group_url(@course, @group, :json)
json.student_url student_url(@submission.student, :json)

json.marked_points @submission.marked_points do |point|
  json.id point.public_id
  json.rating_url course_coursework_rating_point_url(@course, @submission.coursework, point.rating_point, :json)
  json.notes point.marking_notes do |note|
    json.extract! note, :points_cost
    json.fixed !!note.fixed
    json.url course_group_submission_marked_point_marking_note_url(@course, @group, @submission, point, note, format: :json)
  end
end
