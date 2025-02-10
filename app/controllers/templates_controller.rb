class TemplatesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_template, only: %i[ show edit update destroy ]
  before_action :load_courses, only: %i[ new edit ]

  # GET /templates or /templates.json
  def index
    @templates = Template.order(:name).page(params[:page]).per(params[:per_page] || 10)
  end

  # GET /templates/1 or /templates/1.json
  def show
  end

  # GET /templates/new
  def new
    @template = Template.new
  end

  # GET /templates/1/edit
  def edit
  end

  # POST /templates or /templates.json
  def create
    @template = Template.new(template_params)

    respond_to do |format|
      if @template.save
        format.html { redirect_to template_url(@template), notice: "Template was successfully created." }
        format.json { render :show, status: :created, location: @template }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @template.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /templates/1 or /templates/1.json
  def update
    respond_to do |format|
      if @template.update(template_params)
        format.html { redirect_to template_url(@template), notice: "Template was successfully updated." }
        format.json { render :show, status: :ok, location: @template }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @template.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /templates/1 or /templates/1.json
  def destroy
    @template.destroy!

    respond_to do |format|
      format.html { redirect_to templates_url, notice: "Template was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def course_listing
    @course = Course.public_find(params[:course_id])
    @templates = @course.templates.order(:name)
    @holder_id = params[:id]
  end

  private

  def load_courses
    @courses = Course.all.pluck(:id, :name).map { |arr| { id: arr[0], name: arr[1] } }
  end

  def set_template
    @template = Template.public_find(params[:id])
  end

  def template_params
    params.expect(template: [:name, :course_id, :data])
  end
end
