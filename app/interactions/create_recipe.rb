# frozen_string_literal: true

require_relative '../models/ingredient'

class CreateRecipe < ActiveInteraction::Base
  object :user
  hash :params, strip: false

  def execute # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
    i = 0
    new_params = params

    params['recipe_ingredients_attributes'].length.times do
      name = params['recipe_ingredients_attributes'].values[i]['name']
      quantity = params['recipe_ingredients_attributes'].values[i]['quantity']
      next if name == '' || quantity == ''

      new_params['recipe_ingredients_attributes'].values[i].delete('name')
      ingredient = Ingredient.all.select { |ingredient| ingredient.name == name }[0]

      unless ingredient
        ingredient = Ingredient.build(name: name)
        ingredient.save
        ingredient = Ingredient.all.select { |ingredient| ingredient.name == name }[0]
      end

      new_params['recipe_ingredients_attributes'].values[i]['ingredient_id'] = ingredient.id

      i += 1
    end
    user.recipes.build(new_params)
  end
end
