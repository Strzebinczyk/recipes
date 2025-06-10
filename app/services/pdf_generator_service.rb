# frozen_string_literal: true

class PdfGeneratorService
  def initialize # rubocop:disable Metrics/MethodLength
    @pdf = Prawn::Document.new
    @document_width = @pdf.bounds.width
    @pdf.font_families.update(
      'Poppins' => {
        normal: Rails.root.join('app/assets/fonts/Poppins-Regular.ttf'),
        bold: Rails.root.join('app/assets/fonts/Poppins-Bold.ttf'),
        italic: Rails.root.join('app/assets/fonts/Poppins-Italic.ttf'),
        bold_italic: Rails.root.join('app/assets/fonts/Poppins-BoldItalic.ttf')
      },
      'Stylish Calligraphy' => {
        normal: Rails.root.join('app/assets/fonts/StylishCalligraphyDemo-XPZZ.ttf')
      }
    )
  end

  def header
    @pdf.font 'Stylish Calligraphy', style: :normal
    @pdf.text('Lista zakupów', align: :center, size: 36)
    @pdf.move_down 30
  end

  def content(list_items_array)
    @pdf.font 'Poppins', style: :normal
    checklist(list_items_array)
  end

  def checklist(items) # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
    items.each_slice(2) do |item_pair|
      @pdf.start_new_page if @pdf.cursor < 30

      @pdf.stroke_rectangle [0, @pdf.cursor - 1], 15, 15
      @pdf.text_box item_pair[0], at: [20, @pdf.cursor], width: @pdf.bounds.width / 2
      if item_pair[1]
        @pdf.stroke_rectangle [@pdf.bounds.width / 2, @pdf.cursor - 1], 15, 15
        @pdf.text_box item_pair[1], at: [(@pdf.bounds.width / 2) + 20, @pdf.cursor], width: @pdf.bounds.width / 2
      end

      longer_item = if !item_pair[1] || item_pair[0].length >= item_pair[1].length
                      item_pair[0]
                    else
                      item_pair[1]
                    end
      @pdf.move_down 26 * (longer_item.length / 37) if longer_item.length >= 37
      @pdf.move_down 26
    end
  end

  def generate_pdf(list_items_array)
    header
    content(list_items_array)
    @pdf.render
  end
end
