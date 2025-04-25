# frozen_string_literal: true

module Recipes
  class Update < ActiveInteraction::Base
    hash :params, strip: false
    string :id

    def execute # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
      i = 0
      new_recipe_ingredients_attributes = {}

      return params unless params['recipe_ingredients_attributes']

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
      { recipe_ingredients_attributes: new_recipe_ingredients_attributes, **params }
    end
  end
end
