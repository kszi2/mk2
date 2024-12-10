module CoursesHelper
  def default_style_name(course)
    return "<none>" if course.default_rating_style.nil?
    course.default_rating_style.name
  end
end
