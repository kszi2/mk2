class GroupsController < ApplicationController
  before_action :set_group, only: %i[ show edit update destroy add_students remove_student send_attendance ]
  before_action :set_course

  # GET /groups or /groups.json
  def index
    @groups = Group.includes(:course, :course_type).where(course_id: params[:course_id]).all
  end

  # GET /groups/1 or /groups/1.json
  def show
    respond_to do |format|
      format.html
      format.json
      format.pdf do
        begin
          doc = @group.attendance_sheet(*parse_attendance_sheet_data)
          send_data doc.file.download, filename: "#{@group.name}.pdf", type: 'application/pdf'
        ensure
          doc.destroy!
        end
      end
    end
  end

  def send_attendance
    @group.send_attendance_sheet(*parse_attendance_sheet_data)
    respond_to do |format|
      format.html { redirect_to course_group_path(@course, @group), notice: "Attendance sheet was successfully queued for sending." }
    end
  end

  # GET /groups/new
  def new
    @group = Group.new course: @course
  end

  # GET /groups/1/edit
  def edit
  end

  # POST /groups or /groups.json
  def create
    @group = Group.new(group_params)

    respond_to do |format|
      if @group.save
        format.html { redirect_to course_group_url(@course, @group), notice: "Group was successfully created." }
        format.json { render :show, status: :created, location: @group }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  def add_students
  end

  def prepare_students
    if params[:stage]
      stage_students
    else
      set_group
      add_students_impl
    end
  end

  def remove_student
    to_delete = Student.where(neptun: params[:neptun])
    unless to_delete.blank?
      @group.students.delete(to_delete)
      @group.save
    end

    respond_to do |format|
      format.html { redirect_to course_group_url(@course, @group) }
    end
  end

  # PATCH/PUT /groups/1 or /groups/1.json
  def update
    respond_to do |format|
      if @group.update(group_params)
        format.html { redirect_to course_group_url(@course, @group), notice: "Group was successfully updated." }
        format.json { render :show, status: :ok, location: @group }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1 or /groups/1.json
  def destroy
    @group.destroy!

    respond_to do |format|
      format.html { redirect_to course_groups_path(@course), notice: "Group was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def parse_attendance_sheet_data
    date = Date.today
    unless params[:date].blank?
      begin
        date = Date.parse(params[:date])
      rescue
        # ignore, use default
      end
    end
    sort = :name
    if !params[:sort].blank? && params[:sort].in?(["name", "neptun"])
      sort = params[:sort].to_sym
    end

    [date, sort]
  end

  def stage_students
    current_neptuns = params[:current_neptuns].upcase.split(";")
    next_neptuns = Student.where(neptun: current_neptuns).pluck(:neptun).map(&:upcase)

    unless params[:manual_neptuns].blank?
      manual_neptuns = params[:manual_neptuns].upcase.split(";")
      manual_neptuns.each { |n| current_neptuns << n }
      Student.where(neptun: manual_neptuns).pluck(:neptun).map(&:upcase).each do |n|
        next_neptuns << n
      end
    end

    unless params[:import_file].blank?
      csv_neptuns = []
      CSV.foreach(params[:import_file].path, headers: true) do |row|
        current_neptuns << row["neptun"].upcase
        csv_neptuns << row["neptun"].upcase
      end
      Student.where(neptun: csv_neptuns).pluck(:neptun).map(&:upcase).each do |n|
        next_neptuns << n
      end
    end

    next_neptuns.sort!.uniq!
    @missing_neptuns = current_neptuns - next_neptuns
    @current_neptuns = next_neptuns

    respond_to do |format|
      format.turbo_stream { render :prepare_students }
    end
  end

  def add_students_impl
    current_neptuns = params[:current_neptuns].upcase.split(";")
    @students = Student.where(neptun: current_neptuns)
    @students.each do |student|
      @group.students << student
    end
    @group.save

    respond_to do |format|
      format.html { redirect_to course_group_url(@course, @group), notice: "Added students!" }
    end
  end

  def set_course
    if @group.nil?
      @course = Course.find(params[:course_id])
    else
      @course = @group.course
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_group
    group_id = params[:group_id] || params[:id]
    @group = Group.includes(:course, :course_type).find(group_id)
  end

  # Only allow a list of trusted parameters through.
  def group_params
    ret = params.require(:group).permit(:course_id, :course_type_id, :name, :year, :semester, :first_date, :repeat_times, :day_difference)
    ret.except(:course_type)
  end
end
