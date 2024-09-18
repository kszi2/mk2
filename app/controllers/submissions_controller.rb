class SubmissionsController < ApplicationController
  before_action :set_parents
  before_action :set_submission, only: %i[ show edit update destroy ]

  # GET /submissions or /submissions.json
  def index
    @submissions = Submission
                     .includes(:student, :coursework)
                     .where(coursework_id: @courseworks.pluck(:id))
                     .where(student_id: @group.students.pluck(:id))
                     .all
  end

  # GET /submissions/1 or /submissions/1.json
  def show
    respond_to do |format|
      format.html
      format.prog2 { render partial: 'submission', format: :prog2 }
      format.prog1 { render partial: 'submission', format: :prog1 }
    end
  end

  def filter
    @submissions = Submission
                     .includes(:student, :coursework)
                     .where(coursework_id: @courseworks.pluck(:id))
                     .where(student_id: @group.students.pluck(:id))
                     .all
    respond_to do |format|
      format.turbo_stream
    end
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
        format.html { redirect_to course_group_submission_path(@course, @group, @submission), notice: "Submission was successfully created." }
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
        format.html { redirect_to course_group_submission_path(@course, @group, @submission), notice: "Submission was successfully updated." }
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
    @group = Group.includes(:students).where(id: params.require(:group_id)).first!
    @course = Course.find(params.require(:course_id))
    @courseworks = @course.courseworks.where(for_type_id: @group.course_type_id)
    if params.key?(:coursework_id) && !params[:coursework_id].blank?
      @courseworks = @courseworks.where(id: params.require(:coursework_id))
    end
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
