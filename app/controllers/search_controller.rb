# frozen_string_literal: true

class SearchController < ApplicationController
  def index
    @query = Recipe.ransack(params[:q])
    @searched_recipes = @query.result(distinct: true)
  end
end
