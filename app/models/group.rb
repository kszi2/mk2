class Group < ApplicationRecord
  belongs_to :course
  has_and_belongs_to_many :students

  validates :name, presence: true, uniqueness: { scope: :course_id }
  validates :year, presence: true
  validates :semester, presence: true, numericality: { only_integer: true }, inclusion: { in: 1..2 }
  validates :first_date, presence: true, uniqueness: { scope: [:course_id, :year, :semester] }
  validates :repeat_times, presence: true, numericality: { only_integer: true }, inclusion: { in: 0..14 }
  validates :day_difference, presence: true, numericality: { only_integer: true }, inclusion: { in: 1..(7 * 14) }

  def dates_for_class
    (0..repeat_times).map do |entry|
      first_date + (day_difference * entry).days
    end
  end

  def send_attendance_sheet(*args)
    pdf = attendance_sheet(*args)
    SendToDiscordWebhookJob.perform_later(pdf.render, "#{name}.pdf")
  end

  def attendance_sheet(date = Date.today, sort = :name, title = "Jelenléti ív")
    me = self
    golyok = students.sort_by(&sort)
    Prawn::Document::new do
      text title, size: 24, align: :center
      move_down 5

      third = bounds.width / 3
      bounding_box [0, cursor], width: third, height: 17 do
        text me.course.name, style: :italic, valign: :center
      end

      bounding_box [third, cursor + 17], width: third, height: 17 do
        text me.name, align: :center, size: 16, valign: :center
      end

      bounding_box [2 * third, cursor + 17], width: third, height: 17 do
        text date.strftime("%F"), align: :right, valign: :center
      end

      move_down 11
      golyok.each_with_index do |g, i|
        offset = 19
        bounding_box [0, cursor], width: bounds.width, height: offset do
          index_pad = (Math.log10(golyok.length).ceil + 1) * 8
          bounding_box [5, offset], width: index_pad, height: offset do
            text "#{i + 1}", valign: :center
          end
          bounding_box [index_pad + 5, offset], width: 260, height: offset do
            text_box g.name, valign: :center, overflow: :shrink_to_fit
          end
          bounding_box [index_pad + 265, offset], width: 60, height: offset do
            font 'Courier' do
              text "#{g.neptun[0..2].upcase}***", valign: :center
            end
          end

          # checkbox
          bounding_box [index_pad + 345, offset - (offset - 11) / 2], width: 11, height: 11 do
            stroke_bounds
          end
        end

        # guideline
        transparent(0.5) { stroke_horizontal_rule }
      end
    end
  end
end
