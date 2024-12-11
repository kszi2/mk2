json.id @course_type.public_id
json.extract! @course_type, :name, :course_id, :created_at, :updated_at
json.url course_course_type_url(@course_type.course, @course_type, format: :json)
json.course_url course_url(@course_type.course, :json)
