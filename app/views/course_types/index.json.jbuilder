json.objects do
  json.array! @course_types, partial: "course_types/course_type", as: :course_type
end
