class CourseTypesController < ApplicationController
  before_action :set_course_type, only: %i[ show edit update destroy ]
  before_action :set_course

  api :GET, "/course/:course_id/course_types", "Lists course types"
  param :course_id, Integer, "ID of the course this course type is part of"
  def index
    @course_types = CourseType.where(course: @course).page(params[:page]).per(params[:per_page] || 25)
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
        format.html { redirect_to course_course_type_path(@course, @course_type), notice: "Course type was successfully created." }
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
        format.html { redirect_to course_course_type_url(@course, @course_type), notice: "Course type was successfully updated." }
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
      format.html { redirect_to course_course_types_url(@course), notice: "Course type was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_course
    if @course_type.nil?
      @course = Course.find(params.require(:course_id))
    else
      @course = @course_type.course
    end
  end

  def set_course_type
    @course_type = CourseType.includes(:course).find(params[:id])
  end

  def course_type_params
    params.require(:course_type).permit(:name, :course_id)
  end
end
