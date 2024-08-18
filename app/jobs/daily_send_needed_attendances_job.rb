class DailySendNeededAttendancesJob < ApplicationJob
  queue_as :default

  def perform(*args)
    today = Date.today
    tomorrow = Date.tomorrow

    semester = today.month < 7 ? 1 : 2
    real_semester_begin = today.month < 7 \
                            ? Date.parse("#{today.year}-09-01")
                            : Date.parse("#{today.year}-02-01")
    real_semester_end = today.month < 7 \
                          ? Date.parse("#{today.year}-01-31")
                          : Date.parse("#{today.year}-06-30")
    real_semester = real_semester_begin..real_semester_end

    Group.includes(:course, :students)
         .where(semester: semester, year: real_semester)
         .find_each(batch_size: 100) do |group|
      # skip group, unless there is a class tomorrow
      next unless group.dates_for_class.contains(tomorrow)

      group.send_attendance_sheet tomorrow
    end
  end
end
