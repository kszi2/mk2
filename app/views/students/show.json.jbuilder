json.id @student.public_id
json.extract! @student, :name, :neptun, :created_at, :updated_at
json.url student_url(@student, format: :json)

json.groups @student.groups do |group|
  json.name group.name
  json.url course_group_url(group.course, group, :json)
  json.course do
    json.extract! group.course, :name
    json.url course_url(group.course, :json)
  end
end
