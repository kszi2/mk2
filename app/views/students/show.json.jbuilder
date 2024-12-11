json.extract! @student, :id, :public_id, :name, :neptun, :created_at, :updated_at
json.url student_url(@student, format: :json)

json.groups @student.groups do |group|
  json.extract! group, :id, :name
  json.url course_group_url(group.course, group, :json)
  json.course do
    json.extract! group.course, :id, :name
    json.url course_url(group.course, :json)
  end
end
