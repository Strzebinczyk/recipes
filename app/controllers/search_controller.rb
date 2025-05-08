# frozen_string_literal: true

class SearchController < ApplicationController
  def index
    search = "%#{Recipe.sanitize_sql_like(params[:query] || '')}%"
    @searched_recipes = Recipe.joins(:ingredients, :steps, :tags)
                              .where(
                                'lower(recipes.name) LIKE lower(?) or
                                 lower(ingredients.name) LIKE lower(?) or
                                 lower(steps.instructions) LIKE lower(?) or
                                 lower(tags.name) LIKE lower(?)',
                                search, search, search, search
                              ).distinct
  end
end
