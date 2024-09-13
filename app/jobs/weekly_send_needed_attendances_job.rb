class WeeklySendNeededAttendancesJob < ApplicationJob
  queue_as :default

  def perform(*args)
    today = Date.today
    next_week = Date.today + 1.week

    semester = today.semester_number
    real_semester = today.semester_range

    Group.includes(:course, :students)
         .where(semester: semester, year: real_semester)
         .find_each(batch_size: 100) do |group|
      # skip group, unless next week has a class
      next unless group.next_class_date.in?(today..next_week)

      group.send_attendance_sheet :next
    end
  end
end
