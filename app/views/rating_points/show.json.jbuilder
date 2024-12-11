json.extract! @rating_point, :id, :public_id, :name, :description, :available_points, :category, :ordering, :created_at, :updated_at

json.url course_coursework_rating_point_url(@course, @coursework, @rating_point, format: :json)
json.course_url course_url(@course)
json.coursework_url course_coursework_url(@course, @coursework)

