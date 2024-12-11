json.extract! rating_point, :id, :public_id, :name, :description, :available_points, :ordering, :category
json.url course_coursework_rating_point_url(rating_point.coursework.course, rating_point.coursework, rating_point, format: :json)
