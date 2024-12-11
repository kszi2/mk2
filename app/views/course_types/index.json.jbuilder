json.objects do
  json.array! @course_types, partial: "course_types/course_type_listing", as: :course_type
end
