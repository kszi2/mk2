json.id @course.public_id
json.extract! @course, :name, :created_at, :updated_at
json.url course_url(@course, format: :json)
json.default_rating_style_url @course.default_rating_style ? rating_style_url(@course.default_rating_style, :json) : nil

# List nested objects
json.groups @course.groups do |group|
  json.name group.name
  json.url course_group_url(@course, group, format: :json)
end

json.course_types @course.course_types do |course_type|
  json.name course_type.name
  json.url course_course_type_url(@course, course_type, format: :json)
end

json.courseworks @course.courseworks do |coursework|
  json.name coursework.name
  json.url course_coursework_url(@course, coursework, format: :json)
end
