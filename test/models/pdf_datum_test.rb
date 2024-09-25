require "test_helper"

class PdfDatumTest < ActiveSupport::TestCase
  test "pdf-datum stores name for file" do
    datum = PdfDatum.from_raw(empty_pdf, "fun.pdf")
    assert_equal "fun.pdf", datum.name
  end

  test "pdf-datum saves the data passed to it to a file" do
    pdf = empty_pdf
    datum = PdfDatum.from_raw(pdf, "fun.pdf")
    assert_equal pdf, datum.file.download
  end

  private

  def empty_pdf
    pdf = Prawn::Document.new do
      text "AAAA"
    end
    pdf.render
  end
end
