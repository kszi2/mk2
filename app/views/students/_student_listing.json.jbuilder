json.id student.public_id
json.extract! student,  :name, :neptun
json.url student_url(student, format: :json)
