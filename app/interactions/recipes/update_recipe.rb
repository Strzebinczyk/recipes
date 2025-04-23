# frozen_string_literal: true

require_relative '../../models/ingredient'
require_relative '../../models/recipe'
require_relative '../../controllers/recipes_controller'

class UpdateRecipe < ActiveInteraction::Base
  hash :params, strip: false
  string :id

  def execute
    # binding.irb
    i = 0
    new_params = params

    return unless params['recipe_ingredients_attributes']

    params['recipe_ingredients_attributes'].length.times do
      if params['recipe_ingredients_attributes'].values[i]['name'] == '' || params['recipe_ingredients_attributes'].values[i]['quantity'] == ''
        return
      end

      name = params['recipe_ingredients_attributes'].values[i]['name']
      new_params['recipe_ingredients_attributes'].values[i].delete('name')
      ingredient = Ingredient.all.select { |ingr| ingr.name == name }[0]
      # binding.irb
      unless ingredient
        ingredient = Ingredient.build(name: name)
        ingredient.save
        # binding.irb
        ingredient = Ingredient.all.select { |ingr| ingr.name == name }[0]
      end

      new_params['recipe_ingredients_attributes'].values[i]['ingredient_id'] = ingredient.id

      i += 1
    end

    new_params
  end
end
