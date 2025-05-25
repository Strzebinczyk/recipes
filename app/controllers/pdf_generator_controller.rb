# frozen_string_literal: true

class PdfGeneratorController < ApplicationController
  def generate_pdf
    respond_to do |format|
      format.html
      format.pdf do
        pdf_service = PdfGeneratorService.new
        file = pdf_service.generate_pdf(params[:array])

        send_data file, filename: "#{params[:name]}.pdf", type: 'application/pdf', disposition: 'inline'
      end
    end
  end

  private

  def generator_params
    params.permit(%i[name format array])
  end
end
