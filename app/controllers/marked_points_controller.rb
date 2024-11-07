class MarkedPointsController < ApplicationController
  before_action :set_parents

  # GET /marked_points or /marked_points.json
  def index
    @marked_points = MarkedPoint.where(submission_id: params[:submission_id])
  end

  private

  def set_parents
    @group = Group.find(params.require(:group_id))
    @course = Course.find(params.require(:course_id))
    @submission = Submission.find(params.require(:submission_id))
  end
end
