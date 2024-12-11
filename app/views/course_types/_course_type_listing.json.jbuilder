json.extract! course_type, :id, :public_id, :name
json.url course_course_type_url(course_type.course, course_type, format: :json)
