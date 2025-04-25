# frozen_string_literal: true

module Recipes
  class Update < ActiveInteraction::Base
    hash :params, strip: false
    object :recipe

    def execute # rubocop:disable Metrics/AbcSize,Metrics/MethodLength,Metrics/CyclomaticComplexity,Metrics/PerceivedComplexity
      if params['recipe_ingredients_attributes']
        new_recipe_ingredients_attributes =
          params['recipe_ingredients_attributes'].transform_values do |recipe_ingredient|
            name = recipe_ingredient['name']
            recipe_ingredient.delete('name')

            ingredient = Ingredient.find_by(name: name)
            ingredient ||= Ingredient.create(name: name)

            recipe_ingredient['ingredient_id'] = ingredient.id
            recipe_ingredient
          end.reject do |recipe_ingredient| # rubocop:disable Style/MultilineBlockChain
            recipe_ingredient['name'] == '' || recipe_ingredient['quantity'] == ''
          end

        new_params = { recipe_ingredients_attributes: new_recipe_ingredients_attributes, **params }
        errors.merge!(recipe.errors) unless recipe.update(new_params)
      else
        errors.merge!(recipe.errors) unless recipe.update(params)
      end

      recipe
    end
  end
end
