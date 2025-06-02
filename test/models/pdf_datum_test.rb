require "test_helper"

class PdfDatumTest < ActiveSupport::TestCase
  setup do
    @pdf_datum = PdfDatum.new(name: "Test PDF")
  end

  test "PdfDatum is public findable" do
    assert_respond_to PdfDatum, :public_find
    assert_respond_to @pdf_datum, :public_id
  end

  test "valid pdf datum should be valid" do
    assert @pdf_datum.valid?
  end

  test "name should be present" do
    @pdf_datum.name = ""
    refute @pdf_datum.valid?
    assert @pdf_datum.errors.added?(:name, :blank)
  end

  test "name length should be within range" do
    @pdf_datum.name = ""
    refute @pdf_datum.valid?

    @pdf_datum.name = "A" * 256
    refute @pdf_datum.valid?
  end

  test "from_raw should create and attach a pdf file" do
    raw_pdf_content = "%PDF-1.4 example content"
    pdf_datum = PdfDatum.from_raw(raw_pdf_content, "sample.pdf")

    assert pdf_datum.persisted?
    assert pdf_datum.file.attached?
    assert_equal "sample.pdf", pdf_datum.file.filename.to_s
    assert_equal "application/pdf", pdf_datum.file.content_type
  end

  test "send_to_discord should enqueue SendToDiscordWebhookJob" do
    @pdf_datum.save!
    mock_job = mock()
    mock_job.expects(:perform_later).with(@pdf_datum.id, "Test PDF.pdf").returns(nil)
    @pdf_datum.discord_job = mock_job

    @pdf_datum.send_to_discord
  end
end
