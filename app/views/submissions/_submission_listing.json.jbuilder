json.extract! submission, :id, :total_points
json.marked_for submission.marked_for
json.url course_group_submission_url(submission.coursework.course,
                                     group,
                                     submission,
                                     format: :json)
