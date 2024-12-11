json.id coursework.public_id
json.extract! coursework, :name, :active
json.url course_coursework_url(coursework.course, coursework, format: :json)
