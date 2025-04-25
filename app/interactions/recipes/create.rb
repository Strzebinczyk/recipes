# frozen_string_literal: true

module Recipes
  class Create < ActiveInteraction::Base
    object :user
    hash :params, strip: false

    def execute # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
      i = 0
      new_recipe_ingredients_attributes = {}

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
      user.recipes.build(new_params)
    end
  end
end
