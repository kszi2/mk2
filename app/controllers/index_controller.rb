class IndexController < ApplicationController
  before_action :authenticate_user!

  def index
    current_semester = Date.today.semester_range
    @groups = policy_scope(Group)
                .includes(:course)
                .where(first_date: current_semester)
                .page(params[:page]).per(params[:per_page])
  end
end
