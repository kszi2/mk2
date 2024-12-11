json.extract! group, :id, :public_id, :name
json.url course_group_url(group.course, group, format: :json)
