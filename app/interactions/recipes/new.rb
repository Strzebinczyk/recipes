# frozen_string_literal: true

module Recipes
  class New < ActiveInteraction::Base
    def execute
      recipe = Recipe.new
      recipe.steps.build
      recipe.ingredients.build
      recipe.recipe_ingredients.build
      recipe
    end
  end
end
