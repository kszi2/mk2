class MarkedPointsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_parents

  # GET /marked_points or /marked_points.json
  def index
    @marked_points = MarkedPoint.joins(:rating_point)
                                .order("rating_points.ordering")
                                .includes(:rating_point)
                                .where(submission: @submission)
    @marked_points.each { |mp| mp.marking_notes.load }
  end

  private

  def set_parents
    @group = Group.public_find(params.require(:group_id))
    @course = Course.public_find(params.require(:course_id))
    @submission = Submission.public_find(params.require(:submission_id))
  end
end
