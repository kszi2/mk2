json.extract! @coursework, :id, :public_id, :name, :active, :created_at, :updated_at
json.url course_coursework_url(@course, @coursework, format: :json)
json.course_url course_url(@coursework.course, :json)

json.criteria_count @coursework.criteria_count
json.total_points @coursework.total_points

json.for_type do
  json.name @coursework.for_type.name
  json.url course_course_type_url(@coursework.course, @coursework.for_type, format: :json)
end

json.rating_points @coursework.rating_points do |rp|
  json.name rp.name
  json.url course_coursework_rating_point_url @coursework.course, @coursework, rp, format: :json
end
