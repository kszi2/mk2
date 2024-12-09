class SubmissionsController < ApplicationController
  include Filterable

  before_action :set_parents, except: :filter_for
  before_action :set_submission, only: %i[ show edit update destroy ]

  # GET /submissions or /submissions.json
  def index
    @submissions = Submission
                     .includes(:student, :coursework)
                     .where(construct_filter_obj(Submission,
                                                 [:student => [], :coursework => []]))
                     .where(coursework_id: @courseworks.pluck(:id))
                     .where(student_id: @group.students.pluck(:id))
                     .order('students.name', 'courseworks.name')
                     .page(params[:page]).per(params[:per_page] || 25)
  end

  # GET /submissions/1 or /submissions/1.json
  def show
    respond_to do |format|
      format.html
      format.prog2 { render partial: 'submission', format: :prog2 }
      format.prog1 { render partial: 'submission', format: :prog1 }
    end
  end

  def filter_for
    inner_filter_for Submission do |x|
      x.joins(student: :groups)
       .where(groups: { id: params.require(:group_id) })
       .page(params[:page]).per(params[:per_page] || 25)
       .distinct
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

      raise ActiveRecord::Rollback unless succ
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
    @group = Group.includes(:students).find(params.require(:group_id))
    @course = Course.includes(:courseworks).find(params.require(:course_id))
    @courseworks = @course.courseworks.where(for_type_id: @group.course_type_id)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_submission
    @submission = Submission.includes(:rating_points,
                                      :coursework,
                                      marked_points: [
                                        :marking_notes,
                                        :rating_point
                                      ])
                            .find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def submission_params
    params.require(:submission).permit(:student_id, :coursework_id)
  end
end
