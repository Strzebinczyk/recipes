# frozen_string_literal: true

class PdfGeneratorController < ApplicationController
  def generate_pdf
    respond_to do |format|
      format.html
      format.pdf do
        pdf_service = PdfGeneratorService.new
        file = pdf_service.generate_pdf(params[:ingredients_array].compact_blank)

        send_data file, filename: "#{params[:name]}.pdf", type: 'application/pdf', disposition: 'inline'
      end
    end
  end
end
