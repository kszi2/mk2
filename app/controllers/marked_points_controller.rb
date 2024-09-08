class MarkedPointsController < ApplicationController
  before_action :set_parents
  before_action :set_marked_point, only: %i[ show edit update destroy ]

  # GET /marked_points or /marked_points.json
  def index
    @marked_points = MarkedPoint.where(submission_id: params[:submission_id])
  end

  # GET /marked_points/1 or /marked_points/1.json
  def show
  end

  # GET /marked_points/new
  def new
    @marked_point = MarkedPoint.new
  end

  # GET /marked_points/1/edit
  def edit
  end

  # POST /marked_points or /marked_points.json
  def create
    @marked_point = MarkedPoint.new(marked_point_params)

    respond_to do |format|
      if @marked_point.save
        format.html { redirect_to marked_point_url(@marked_point), notice: "Marked point was successfully created." }
        format.json { render :show, status: :created, location: @marked_point }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @marked_point.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /marked_points/1 or /marked_points/1.json
  def update
    respond_to do |format|
      if @marked_point.update(marked_point_params)
        format.html { redirect_to marked_point_url(@marked_point), notice: "Marked point was successfully updated." }
        format.json { render :show, status: :ok, location: @marked_point }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @marked_point.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /marked_points/1 or /marked_points/1.json
  def destroy
    @marked_point.destroy!

    respond_to do |format|
      format.html { redirect_to marked_points_url, notice: "Marked point was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_parents
    @group = Group.find(params.require(:group_id))
    @course = Course.find(params.require(:course_id))
    @submission = Submission.find(params.require(:submission_id))
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_marked_point
    @marked_point = MarkedPoint.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def marked_point_params
    params.require(:marked_point).permit(:submission_id, :rating_point_id)
  end
end
