json.extract! @submission, :id, :public_id, :created_at, :updated_at
json.url course_group_submission_url(@course, @group, @submission, format: :json)

json.course_url course_url(@course, :json)
json.group_url course_group_url(@course, @group, :json)
json.student_url student_url(@submission.student, :json)

json.marked_points @submission.marked_points do |point|
  json.extract! point, :id, :public_id
  json.notes point.marking_notes do |note|
    json.extract! note, :id, :public_id, :points_cost
    json.fixed !!note.fixed
  end
end
