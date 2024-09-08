class SubmissionsController < ApplicationController
  before_action :set_parents
  before_action :set_submission, only: %i[ show edit update destroy ]

  # GET /submissions or /submissions.json
  def index
    @submissions = Submission.all
  end

  # GET /submissions/1 or /submissions/1.json
  def show
  end

  # GET /submissions/new
  def new
    @submission = Submission.new
  end

  # GET /submissions/1/edit
  def edit
  end

  # POST /submissions or /submissions.json
  def create
    succ = false
    Submission.transaction do
      @submission = Submission.new(submission_params)
      succ = @submission.save

      if succ
        rating_points = @submission.coursework.rating_points

        rating_points.each do |rp|
          mp = MarkedPoint.new submission_id: @submission.id, rating_point_id: rp.id
          succ = mp.save
          break unless succ
        end
      end

      rollback unless succ
    end

    respond_to do |format|
      if succ
        format.html { redirect_to course_group_path(@course, @group), notice: "Submission was successfully created." }
        format.json { render :show, status: :created, location: @submission }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @submission.errors, status: :unprocessable_entity }
      end
    end
  end

  def header
    respond_to do |format|
      format.html { render partial: 'header', locals: { objs: [@course, @group] } }
    end
  end

  # PATCH/PUT /submissions/1 or /submissions/1.json
  def update
    respond_to do |format|
      if @submission.update(submission_params)
        format.html { redirect_to course_group_path(@course, @group), notice: "Submission was successfully updated." }
        format.json { render :show, status: :ok, location: @submission }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @submission.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /submissions/1 or /submissions/1.json
  def destroy
    @submission.destroy!

    respond_to do |format|
      format.html { redirect_to course_group_path(@course, @group), notice: "Submission was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_parents
    @group = Group.includes(:students).find(params.require(:group_id))
    @course = Course.find(params.require(:course_id))
    @courseworks = @course.courseworks.filter { |cw| cw.for_type = @group.course_type }
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_submission
    @submission = Submission.includes(:marked_points).find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def submission_params
    params.require(:submission).permit(:student_id, :coursework_id)
  end
end
