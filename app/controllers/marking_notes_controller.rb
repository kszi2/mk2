class MarkingNotesController < ApplicationController
  before_action :set_parents
  before_action :set_marking_note, only: %i[ show edit update toggle destroy ]

  # GET /marking_notes or /marking_notes.json
  def index
    @marking_notes = MarkingNote.where(marked_point: @marked_point).all
  end

  # GET /marking_notes/new
  def new
    @marking_note = MarkingNote.new
  end

  def make_marking
    @marking_note = MarkingNote.new(marked_point: @marked_point)
    respond_to do |format|
      format.turbo_stream
    end
  end

  def cancel_make
    set_marking_note unless params[:marking_note_id].blank?
    respond_to do |format|
      format.turbo_stream
    end
  end

  def show
    respond_to do |format|
      format.html
      format.json
    end
  end

  # GET /marking_notes/1/edit
  def edit
  end

  def toggle
    @marking_note.fixed = !@marking_note.fixed
    @marking_note.save!
  end

  # POST /marking_notes or /marking_notes.json
  def create
    @marking_note = MarkingNote.new(marking_note_params)

    respond_to do |format|
      if @marking_note.save
        format.turbo_stream { render }
        format.html do
          redirect_to course_group_submission_marked_point_marking_notes_path(
                        @course,
                        @group,
                        @submission,
                        @marked_point),
                      notice: "Marking note was successfully created."
        end
        format.json
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @marking_note.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /marking_notes/1 or /marking_notes/1.json
  def update
    respond_to do |format|
      if @marking_note.update(marking_note_params)
        format.html { redirect_to course_group_submission_marked_point_marking_note_path(@course, @group, @submission, @marked_point, @marking_note) }
        format.json { render :show, status: :ok, location: @marking_note }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @marking_note.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /marking_notes/1 or /marking_notes/1.json
  def destroy
    @marking_note.destroy!

    respond_to do |format|
      flash[:success] = "Marking note was successfully destroyed."
      format.turbo_stream do
        render
      end
      format.html do
        redirect_to course_group_submission_path(@course, @group, @submission)
      end
      format.json { head :no_content }
    end
  end

  private

  def set_parents
    @group = Group.public_find(params.require(:group_id))
    @course = Course.public_find(params.require(:course_id))
    @submission = Submission.public_find(params.require(:submission_id))
    @marked_point = MarkedPoint.public_find(params.require(:marked_point_id))
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_marking_note
    @marking_note = MarkingNote.public_find(params[:id] || params[:marking_note_id])
  end

  # Only allow a list of trusted parameters through.
  def marking_note_params
    ret = params.require(:marking_note).permit(:points_cost, :reason, :fixed)
    ret.merge(marked_point_id: @marked_point.id)
  end
end
