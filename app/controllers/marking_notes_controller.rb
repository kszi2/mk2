class MarkingNotesController < ApplicationController
  before_action :set_parents
  before_action :set_marking_note, only: %i[ show edit update destroy ]

  # GET /marking_notes or /marking_notes.json
  def index
    @marking_notes = MarkingNote.where(marked_point_id: params[:marked_point_id]).all
  end

  # GET /marking_notes/1 or /marking_notes/1.json
  def show
  end

  # GET /marking_notes/new
  def new
    @marking_note = MarkingNote.new
  end

  def make_marking
    @marking_note = MarkingNote.new
    respond_to do |format|
      format.turbo_stream
    end
  end

  def cancel_make
    respond_to do |format|
      format.turbo_stream
    end
  end

  # GET /marking_notes/1/edit
  def edit
  end

  # POST /marking_notes or /marking_notes.json
  def create
    @marking_note = MarkingNote.new(marking_note_params)

    respond_to do |format|
      if @marking_note.save
        format.turbo_stream { render }
        format.html { redirect_to course_group_submission_marked_point_marking_notes_path(@marking_note), notice: "Marking note was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /marking_notes/1 or /marking_notes/1.json
  def update
    respond_to do |format|
      if @marking_note.update(marking_note_params)
        format.html { redirect_to marking_note_url(@marking_note), notice: "Marking note was successfully updated." }
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
      format.html { redirect_to marking_notes_url, notice: "Marking note was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_parents
    @group = Group.find(params.require(:group_id))
    @course = Course.find(params.require(:course_id))
    @submission = Submission.find(params.require(:submission_id))
    @marked_point = MarkedPoint.find(params.require(:marked_point_id))
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_marking_note
    @marking_note = MarkingNote.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def marking_note_params
    params.require(:marking_note).permit(:points_cost, :reason, :fixed, :marked_point_id)
  end
end
