# frozen_string_literal: true

class CreateRecipe < ActiveInteraction::Base
  object :user
  hash :params, strip: false

  def execute
    quantity = []
    i = 0
    new_params = params
    if params['ingredients_attributes'].instance_of?(Array)
      params['ingredients_attributes'].length.times do
        ingredient_recipe = { 'ingredient_id' => nil,
                              'quantity' => params['ingredients_attributes'][i]['quantity'] }
        quantity.append ingredient_recipe
        new_params['ingredients_attributes'][i].delete('quantity')
        i += 1
      end
    elsif params['ingredients_attributes'].instance_of?(ActiveSupport::HashWithIndifferentAccess)
      params['ingredients_attributes'].length.times do
        ingredient_recipe = { 'ingredient_id' => params['ingredients_attributes'].keys[i],
                              'quantity' => params['ingredients_attributes'].values[i]['quantity'] }
        quantity.append ingredient_recipe
        new_params['ingredients_attributes'].values[i].delete('quantity')
        i += 1
      end
    end
    recipe = user.recipes.build(new_params)
    binding.irb
  end
end
