class CourseTypesController < ApplicationController
  before_action :set_course_id
  before_action :set_course_type, only: %i[ show edit update destroy ]
  before_action :set_course

  # GET /course_types or /course_types.json
  def index
    @course_types = CourseType.where(course_id: @course_id).all
  end

  # GET /course_types/1 or /course_types/1.json
  def show
  end

  # GET /course_types/new
  def new
    @course_type = CourseType.new
  end

  # GET /course_types/1/edit
  def edit
  end

  # POST /course_types or /course_types.json
  def create
    @course_type = CourseType.new(course_type_params)

    respond_to do |format|
      if @course_type.save
        format.html { redirect_to course_course_type_path(@course_id, @course_type), notice: "Course type was successfully created." }
        format.json { render :show, status: :created, location: @course_type }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @course_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /course_types/1 or /course_types/1.json
  def update
    respond_to do |format|
      if @course_type.update(course_type_params)
        format.html { redirect_to course_course_type_path(@course, @course_type), notice: "Course type was successfully updated." }
        format.json { render :show, status: :ok, location: @course_type }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @course_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /course_types/1 or /course_types/1.json
  def destroy
    @course_type.destroy!

    respond_to do |format|
      format.html { redirect_to course_path(@course, page: :course_type), notice: "Course type was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_course
    if @course_type.nil?
      @course = Course.find(@course_id)
    else
      @course = @course_type.course
    end
  end

  private

  def set_course_id
    @course_id = params.require(:course_id)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_course_type
    @course_type = CourseType.includes(:course).find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def course_type_params
    params.require(:course_type).permit(:name, :course_id)
  end
end
