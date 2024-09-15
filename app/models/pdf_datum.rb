class PdfDatum < ApplicationRecord
  has_one_attached :file

  validates :name, presence: true, length: { in: 1..255 }

  def PdfDatum.from_raw(raw, name)
    datum = PdfDatum.new(name: name)
    datum.file.attach(io: StringIO.new(raw),
                      filename: name,
                      content_type: "application/pdf")
    datum.save!
    datum
  end

  def send_to_discord
    SendToDiscordWebhookJob.perform_later(id, "#{name}.pdf")
  end
end
