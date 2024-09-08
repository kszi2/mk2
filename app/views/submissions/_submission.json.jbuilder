json.extract! submission, :id, :student_id, :coursework_id, :created_at, :updated_at
json.url submission_url(submission, format: :json)
