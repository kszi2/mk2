json.extract! @course, :id, :public_id, :name, :default_rating_style_id, :created_at, :updated_at
json.url course_url(@course, format: :json)
json.default_rating_style_url @course.default_rating_style ? rating_style_url(@course.default_rating_style, :json) : nil

# List nested objects
json.groups do
  json.array! @course.groups do |group|
    json.name group.name
    json.url course_group_url(@course, group, format: :json)
  end
end

json.course_types do
  json.array! @course.course_types do |course_type|
    json.name course_type.name
    json.url course_course_type_url(@course, course_type, format: :json)
  end
end

json.courseworks do
  json.array! @course.courseworks do |coursework|
    json.name coursework.name
    json.url course_coursework_url(@course, coursework, format: :json)
  end
end
