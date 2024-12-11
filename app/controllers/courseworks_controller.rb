class CourseworksController < ApplicationController
  before_action :set_coursework, only: %i[ show edit update destroy reorder ]
  before_action :set_course

  # GET /courseworks or /courseworks.json
  def index
    @courseworks = Coursework.includes(:for_type, :course)
                             .where(course: @course)
                             .page(params[:page]).per(params[:per_page] || 25)
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

  def reorder
    dropped_id = params.require(:dropped_id).gsub(/rating_point_/, '')
    before_id = params.require(:before_id).gsub(/rating_point_/, '')
    dropped = RatingPoint.public_find(dropped_id)
    before = RatingPoint.public_find(before_id)

    @updated_ratings = [dropped]
    RatingPoint.transaction do
      shifted = RatingPoint.where(coursework: @coursework, ordering: before.ordering..)
                           .where.not(id: dropped_id).all
      dropped.ordering = before.ordering
      shifted.zip((dropped.ordering + 1)..).each do |rating, order|
        @updated_ratings << rating
        rating.ordering = order
      end
      dropped.save!
      shifted.each(&:save!)
    end
    render
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
      @course = Course.public_find params.require(:course_id)
    else
      @course = @coursework.course
    end
  end

  def set_coursework
    @coursework = Coursework.includes(:course, :for_type).public_find(params[:id] || params[:coursework_id])
  end

  # Only allow a list of trusted parameters through.
  def coursework_params
    cw_params = params.require(:coursework).permit(:name, :active, :for_type_id)
    cw_params[:for_type_id] = CourseType.decode_id(cw_params[:for_type_id])
    cw_params.merge!(course_id: @course.id)
    cw_params
  end
end
