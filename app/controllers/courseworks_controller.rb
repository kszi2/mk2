class CourseworksController < ApplicationController
  before_action :set_coursework, only: %i[ show edit update destroy ]
  before_action :set_course

  # GET /courseworks or /courseworks.json
  def index
    @courseworks = Coursework.includes(:for_type, :course).all
  end

  # GET /courseworks/1 or /courseworks/1.json
  def show
  end

  # GET /courseworks/new
  def new
    @coursework = Coursework.new
  end

  # GET /courseworks/1/edit
  def edit
  end

  # POST /courseworks or /courseworks.json
  def create
    @coursework = Coursework.new(coursework_params)

    respond_to do |format|
      if @coursework.save
        format.html { redirect_to course_coursework_url(@course, @coursework), notice: "Coursework was successfully created." }
        format.json { render :show, status: :created, location: [@course, @coursework] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @coursework.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /courseworks/1 or /courseworks/1.json
  def update
    respond_to do |format|
      if @coursework.update(coursework_params)
        format.html { redirect_to course_coursework_url(@course, @coursework), notice: "Coursework was successfully updated." }
        format.json { render :show, status: :ok, location: [@course, @coursework] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @coursework.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /courseworks/1 or /courseworks/1.json
  def destroy
    @coursework.destroy!

    respond_to do |format|
      format.html { redirect_to course_path(@course), notice: "Coursework was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_course
    if @coursework.nil?
      @course = Course.find params.require(:course_id)
    else
      @course = @coursework.course
    end
  end

  def set_coursework
    @coursework = Coursework.includes(:course, :for_type).find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def coursework_params
    params.require(:coursework).permit(:course_id, :name, :active, :for_type_id)
  end
end
