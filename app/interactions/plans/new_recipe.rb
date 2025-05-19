# frozen_string_literal: true

module Plans
  class NewRecipe < ActiveInteraction::Base
    string :recipe_id

    def execute
      recipe_plan = RecipePlan.new
      recipe = Recipe.find(recipe_id)
      shopping_list_ingredient = ShoppingListIngredient.new
      [recipe_plan, recipe, recipe.id, shopping_list_ingredient]
    end
  end
end
