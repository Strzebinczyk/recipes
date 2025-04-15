class IngredientsController < ApplicationController
  def new
    respond_to do |format|
      format.turbo_stream
    end
  end
end
