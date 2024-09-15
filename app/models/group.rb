class Group < ApplicationRecord
  belongs_to :course
  belongs_to :course_type, optional: true
  has_and_belongs_to_many :students

  validates :name, presence: true, uniqueness: { scope: :course_id }
  validates :year, presence: true
  validates :semester, presence: true, numericality: { only_integer: true }, inclusion: { in: 1..2 }
  validates :first_date, presence: true
  validates :repeat_times, presence: true, numericality: { only_integer: true }, inclusion: { in: 0..14 }
  validates :day_difference, presence: true, numericality: { only_integer: true }, inclusion: { in: 1..(7 * 14) }
  validates :course_type_id, presence: true, on: :create # new groups can only be created with course_type set

  def safe_course_type
    return "<unset>" if course_type.nil?
    course_type.name
  end

  def dates_for_class
    (0..repeat_times - 1).map do |entry|
      first_date + (day_difference * entry).days
    end
  end

  def next_class_date
    rem = dates_for_class.filter { |date| date >= Date.today }
    return nil if rem.empty?
    rem.first
  end

  def send_attendance_sheet(*args)
    pdf = attendance_sheet(*args)
    SendToDiscordWebhookJob.perform_later(pdf.id, "#{name}.pdf")
  end

  def attendance_sheet(date = Date.today, sort = :name, title = "Jelenléti ív")
    real_date = date
    real_date = next_class_date if real_date == :next

    me = self
    golyok = students.order(sort)
    pdf = Prawn::Document::new(page_size: 'A4') do
      font_families.update(
        'IBMPlexSans' => {
          normal: Rails.root.join("IBMPlexSans-Text.ttf"),
          italic: Rails.root.join("IBMPlexSans-Italic.ttf"),
          bold:  Rails.root.join("IBMPlexSans-Bold.ttf"),
        },
        'IBMPlexMono' => {
          normal: Rails.root.join("IBMPlexMono-Text.ttf"),
          italic: Rails.root.join("IBMPlexMono-Italic.ttf"),
          bold:  Rails.root.join("IBMPlexMono-Bold.ttf"),
        }
      )
      font "IBMPlexSans"

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
        text real_date.strftime("%F"), align: :right, valign: :center
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
            font 'IBMPlexMono' do
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
    datum = PdfDatum.new
    datum.file.attach(io: StringIO.new(pdf.render),
                      filename: "#{name}_#{real_date}.pdf",
                      content_type: "application/pdf")
    datum.save!
    datum
  end
end
