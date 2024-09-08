class RatingPointsController < ApplicationController
  before_action :set_rating_point, only: %i[ show edit update destroy ]
  before_action :set_coursework
  before_action :set_course

  # GET /rating_points or /rating_points.json
  def index
    @rating_points = RatingPoint.where(coursework_id: @coursework.id).all
  end

  # GET /rating_points/1 or /rating_points/1.json
  def show
  end

  # GET /rating_points/new
  def new
    @rating_point = RatingPoint.new(coursework: @coursework)
  end

  # GET /rating_points/1/edit
  def edit
  end

  def header
    respond_to do |format|
      format.html { render partial: 'header', locals: { objs: [@course, @coursework] } }
    end
  end

  # POST /rating_points or /rating_points.json
  def create
    @rating_point = RatingPoint.new(rating_point_params)

    respond_to do |format|
      if @rating_point.save
        format.html { redirect_to course_coursework_path(@course, @coursework), notice: "Rating point was successfully created." }
        format.json { render :show, status: :created, location: @rating_point }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @rating_point.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rating_points/1 or /rating_points/1.json
  def update
    respond_to do |format|
      if @rating_point.update(rating_point_params)
        format.html { redirect_to course_coursework_path(@course, @coursework), notice: "Rating point was successfully updated." }
        format.json { render :show, status: :ok, location: @rating_point }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @rating_point.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rating_points/1 or /rating_points/1.json
  def destroy
    @rating_point.destroy!

    respond_to do |format|
      format.html { redirect_to course_coursework_path(@course, @coursework), notice: "Rating point was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_coursework
    if @rating_point.nil?
      @coursework = Coursework.find(params.require(:coursework_id))
    else
      @coursework = @rating_point.coursework
    end
  end

  def set_course
    if @coursework.nil?
      @course = Course.find(params.require(:course_id))
    else
      @course = @coursework.course
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_rating_point
    @rating_point = RatingPoint.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def rating_point_params
    params.require(:rating_point).permit(:name, :description, :available_points, :coursework_id)
  end
end
