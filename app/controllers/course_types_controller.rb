class CourseTypesController < ApplicationController
  before_action :set_course_type, only: %i[ show edit update destroy ]
  before_action :set_course

  def_param_group :course_type do
    param :course_type, Hash, required: true do
      param :name, String, "The name of the course type", required: true
    end
  end

  api :GET, "/course/:course_id/course_types", "Lists course types"
  param :course_id, IdType, "ID of the course this course type is part of", required: true
  def index
    @course_types = CourseType.where(course: @course).page(params[:page]).per(params[:per_page] || 25)
  end

  api :GET, "/course/:course_id/course_types/:id", "Shows course type details"
  param :course_id, IdType, "ID of the course this course type is part of", required: true
  param :id, IdType, "ID of the course type object to show", required: true
  def show
  end

  def new
    @course_type = CourseType.new
  end

  def edit
  end

  api :POST, "/course/:course_id/course_types", "Creates a course type"
  param_group :course_type
  def create
    @course_type = CourseType.new(course: @course, **course_type_params)

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

  api :PUT, "/course/:course_id/course_types/:id", "Updates a course type object"
  param_group :course_type
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

  api :DELETE, "/course/:course_id/course_types/:id", "Deletes a course type object"
  param :course_id, IdType, "ID of the course this course type is part of", required: true
  param :id, IdType, "ID of the course type object to delete", required: true
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
      @course = Course.public_find(params.require(:course_id))
    else
      @course = @course_type.course
    end
  end

  def set_course_type
    @course_type = CourseType.includes(:course).public_find(params[:id])
  end

  def course_type_params
    params.require(:course_type).permit(:name)
  end
end
