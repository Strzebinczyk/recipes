# frozen_string_literal: true

require_relative '../../models/ingredient'
require_relative '../../models/recipe'
require_relative '../../controllers/recipes_controller'

class UpdateRecipe < ActiveInteraction::Base
  hash :params, strip: false
  string :id

  def execute
    i = 0
    new_params = params

    return new_params unless params['recipe_ingredients_attributes']

    params['recipe_ingredients_attributes'].length.times do
      if params['recipe_ingredients_attributes'].values[i]['name'] == '' || params['recipe_ingredients_attributes'].values[i]['quantity'] == ''
        new_params['recipe_ingredients_attributes'].delete(params['recipe_ingredients_attributes'].keys[i])
        next
      end

      name = params['recipe_ingredients_attributes'].values[i]['name']
      new_params['recipe_ingredients_attributes'].values[i].delete('name')
      ingredient = Ingredient.all.select { |ingr| ingr.name == name }[0]

      unless ingredient
        ingredient = Ingredient.build(name: name)
        ingredient.save
        ingredient = Ingredient.all.select { |ingr| ingr.name == name }[0]
      end
      new_params['recipe_ingredients_attributes'].values[i]['ingredient_id'] = ingredient.id

      i += 1
    end
    new_params
  end
end
