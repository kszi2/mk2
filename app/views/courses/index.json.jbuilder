json.objects do
  json.array! @courses, partial: "courses/course_listing", as: :course
end
