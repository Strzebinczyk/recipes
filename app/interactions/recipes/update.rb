# frozen_string_literal: true

module Recipes
  class Update < ActiveInteraction::Base
    hash :params, strip: false
    object :recipe

    def execute # rubocop:disable Metrics/AbcSize,Metrics/MethodLength,Metrics/CyclomaticComplexity,Metrics/PerceivedComplexity
      i = 0
      new_recipe_ingredients_attributes = {}

      if params['recipe_ingredients_attributes']

        params['recipe_ingredients_attributes'].each do
          name = params['recipe_ingredients_attributes'].values[i]['name']
          quantity = params['recipe_ingredients_attributes'].values[i]['quantity']

          next if name == '' || quantity == ''

          new_recipe_ingredients_attributes[params['recipe_ingredients_attributes'].keys[i]] =
            params['recipe_ingredients_attributes'].values[i]
          new_recipe_ingredients_attributes.values[i].delete('name')

          ingredient = Ingredient.find_by(name: name)
          ingredient ||= Ingredient.create(name: name)
          new_recipe_ingredients_attributes.values[i]['ingredient_id'] = ingredient.id

          i += 1
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
