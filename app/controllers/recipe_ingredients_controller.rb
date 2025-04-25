# frozen_string_literal: true

class RecipeIngredientsController < ApplicationController
  def new
    respond_to do |format|
      format.turbo_stream
    end
  end
end
