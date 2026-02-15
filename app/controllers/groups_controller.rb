class GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group, only: %i[
    show edit update destroy
    add_teacher associate_teacher remove_teacher
    add_students remove_student
    send_attendance
  ]
  before_action :set_course

  # GET /groups or /groups.json
  def index
    @groups = Group.includes(:course, :course_type)
                   .where(course: @course)
                   .order(:name)
                   .page(params[:page]).per(params[:per_page] || 25)
  end

  # GET /groups/1 or /groups/1.json
  def show
    @teachers = @group.teachers.page(params[:page]).per(params[:per_page] || 25)
    respond_to do |format|
      format.html
      format.json
      format.pdf do
        begin
          doc = @group.attendance_sheet(*parse_attendance_sheet_data)
          send_data doc.file.download, filename: "#{@group.name}.pdf", type: 'application/pdf'
        rescue => e
          logger.error("error generating group pdf: #{e.message}")
        ensure
          doc.destroy! unless doc.nil?
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

  def add_teacher
    @candidates = User.find_by_sql([ <<~SQL.squish, { group_id: @group.id } ])
      SELECT *
      FROM users
      WHERE id <> ALL (SELECT user_id
                       FROM groups_teachers
                       GROUP BY user_id
                       HAVING :group_id = ANY (array_agg(group_id)))
        AND username <> 'admin';
    SQL

    if @candidates.empty?
      render "no_more_teachers"
    else
      render "add_teacher"
    end
  end

  def associate_teacher
    user_params = params.expect(group: [ :user_id ])
    teach = User.public_find(user_params[:user_id])
    @group.teachers << teach
    @group.save!

    @teachers = @group.teachers.page(params[:page]).per(params[:per_page] || 25)
    render "refresh_teacher"
  end

  def remove_teacher
    @user = User.public_find(params[:id])
    @group.teachers.delete(@user)
    @group.save!

    @teachers = @group.teachers.page(params[:page]).per(params[:per_page] || 25)
    render partial: "teachers"
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
    if params[:sort].present? && params[:sort].in?([ "name", "neptun" ])
      sort = params[:sort].to_sym
    end

    [ date, sort ]
  end

  def stage_students
    current_neptuns = params[:current_neptuns].upcase.split(";")
    next_neptuns = Student.where(neptun: current_neptuns).pluck(:neptun).map(&:upcase)
    rendered_students = []

    unless params[:manual_neptuns].blank?
      manual_neptuns = params[:manual_neptuns].upcase.split(";")
      manual_neptuns.each { |n| current_neptuns << n }
      Student.where(neptun: manual_neptuns).pluck(:name, :neptun).each do |name, neptun|
        rendered_students << [ name, neptun ]
        next_neptuns << neptun.upcase
      end
    end

    unless params[:import_file].blank?
      begin
        file = params[:import_file]
        importer = Importers::ImporterFactory.build_importer_by_heuristic(file)
        found, missing = importer.existing_students
        found.each do |st|
          rendered_students << [ st.name, st.neptun ]
          next_neptuns << st.neptun.upcase
        end
        missing.each do |st|
          current_neptuns << st.neptun.upcase
        end
      rescue NoMemoryError
        # Ignored
      end
    end

    next_neptuns.sort!.uniq!
    @missing_neptuns = current_neptuns - next_neptuns
    @rendered_students = rendered_students
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
      @course = Course.public_find(params[:course_id])
    else
      @course = @group.course
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_group
    group_id = params[:group_id] || params[:id]
    @group = Group.includes(:course, :course_type).public_find(group_id)
  end

  # Only allow a list of trusted parameters through.
  def group_params
    ret = params.require(:group).permit(:course_type_id, :name, :year, :semester, :first_date, :repeat_times, :day_difference)
    ret.merge(course_id: @course.id).except(:course_type)
  end
end
