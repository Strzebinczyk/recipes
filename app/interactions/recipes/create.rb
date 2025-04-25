# frozen_string_literal: true

module Recipes
  class Create < ActiveInteraction::Base
    object :user
    hash :params, strip: false

    def execute # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
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
      user.recipes.build(new_params)
    end
  end
end
