json.id submission.public_id
json.extract! submission, :total_points, :marked_for
json.url course_group_submission_url(submission.coursework.course,
                                     group,
                                     submission,
                                     format: :json)
