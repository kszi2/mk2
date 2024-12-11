json.id @group.public_id
json.extract! @group,  :name, :created_at, :updated_at
json.url course_group_url(@course, @group, format: :json)

json.course_url course_url(@course, format: :json)

json.students do
  json.array! @group.students do |s|
    json.extract! s, :name, :neptun
    json.url student_url(s, :json)
  end
end
