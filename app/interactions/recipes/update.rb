# frozen_string_literal: true

module Recipes
  class Update < ActiveInteraction::Base
    hash :params, strip: false
    object :recipe

    def execute # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
      new_recipe_ingredients_attributes =
        (params['recipe_ingredients_attributes'] || {})
        .reject { _1['name'] == '' || _1['quantity'] == '' }
        .transform_values do |recipe_ingredient|
          name = recipe_ingredient.delete('name')
          ingredient = Ingredient.find_by(name:) || Ingredient.create(name:)

          { **recipe_ingredient, 'ingredient_id' => ingredient.id }
        end

      new_params = { **params, 'recipe_ingredients_attributes' => new_recipe_ingredients_attributes }
      errors.merge!(recipe.errors) unless recipe.update(new_params)

      recipe
    end
  end
end
