class StudentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_import_status
  before_action :set_student, only: %i[ show edit update destroy ]

  # GET /students or /students.json
  def index
    @students = current_user.known_students
                            .order(:name)
                            .page(params[:page])
                            .per(params[:per_page] || 50)
  end

  # GET /students/1 or /students/1.json
  def show
  end

  # GET /students/new
  def new
    @student = Student.new
  end

  # GET /students/1/edit
  def edit
  end

  def import
  end

  def bulk_create
    @invalid_format = false

    file = params.require('file')
    importer = Importers::ImporterFactory.build_importer_by_heuristic(file)
    if importer.nil?
      @new_students = []
      @filename = file.original_filename
      @invalid_format = true
      @students = Student.order(:name).page params[:page]
      render :index
      return
    end

    @new_students = importer.students
    @have_failed = false
    @new_students.each do |student|
      @have_failed = true unless student.save
    end

    respond_to do |format|
      format.html { redirect_to students_path }
      format.turbo_stream {
        @students = Student.order(:name).page params[:page]
        render :index
      }
      format.json { render :show, status: :created }
    end
  end

  # POST /students or /students.json
  def create
    @student = Student.new(student_params)

    respond_to do |format|
      if @student.save
        format.html { redirect_to student_url(@student), notice: "Student was successfully created." }
        format.json { render :show, status: :created, location: @student }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /students/1 or /students/1.json
  def update
    respond_to do |format|
      if @student.update(student_params)
        format.html { redirect_to student_url(@student), notice: "Student was successfully updated." }
        format.json { render :show, status: :ok, location: @student }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /students/1 or /students/1.json
  def destroy
    @student.destroy!

    respond_to do |format|
      format.html { redirect_to students_url, notice: "Student was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_import_status
    @from_import = false
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_student
    @student = Student.includes(submissions: [ :marked_points, coursework: [ rating_points: [ :marked_points ] ] ], groups: [ :course ]).public_find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def student_params
    params.require(:student).permit(:name, :neptun)
  end
end
