class WeeklySendNeededAttendancesJob < ApplicationJob
  queue_as :default

  def perform(*args)
    today = Date.today
    next_week = Date.today + 1.week

    semester = today.semester_number
    real_semester = today.semester_range

    first_iteration = true
    pdf = Prawn::Document::new(page_size: 'A4') do |pdf|
      Group.includes(:course, :students)
           .where(semester: semester, first_date: real_semester)
           .find_each(batch_size: 100) do |group|
        # skip group, unless next week has a class
        next unless group.next_class_date.in?(today..next_week)

        pdf.start_new_page unless first_iteration
        group.render_attendance_sheet pdf, :next
        first_iteration = false
      end
    end

    PdfDatum.from_raw(pdf.render, "week_of_#{today.strftime("%F")}.pdf").send_to_discord
  end
end
