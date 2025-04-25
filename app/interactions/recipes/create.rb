# frozen_string_literal: true

module Recipes
  class Create < ActiveInteraction::Base
    object :user
    hash :params, strip: false

    def execute # rubocop:disable Metrics/MethodLength,Metrics/AbcSize
      new_recipe_ingredients_attributes =
        params['recipe_ingredients_attributes']
        .reject { _1['name'] == '' || _1['quantity'] == '' }
        .transform_values do |recipe_ingredient|
          name = recipe_ingredient.delete('name')
          ingredient = Ingredient.find_by(name: name) || Ingredient.create(name: name)

          { **recipe_ingredient, 'ingredient_id' => ingredient.id }
        end
      new_params = { **params, 'recipe_ingredients_attributes' => new_recipe_ingredients_attributes }
      recipe = user.recipes.build(new_params)

      errors.merge!(recipe.errors) unless recipe.save
      recipe
    end
  end
end
