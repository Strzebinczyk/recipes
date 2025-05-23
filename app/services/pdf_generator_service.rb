class PdfGeneratorService
  def initialize
    @pdf = Prawn::Document.new
    @document_width = @pdf.bounds.width
  end

  def header
    @pdf.text('LISTA ZAKUPÓW')
  end

  def content
  end

  def generate_pdf
    header
    content
    @pdf.render('test.pdf')
  end
end
