# frozen_string_literal: true

module Plans
  class RemoveRecipe < ActiveInteraction::Base
    string :recipe_plan_id

    def execute
      recipe_plan = RecipePlan.find(recipe_plan_id)
      plan = Plan.find(recipe_plan.plan_id)
      recipe = Recipe.find(recipe_plan.recipe_id)
      shopping_list = plan.shopping_list

      ActiveRecord::Base.transaction do
        recipe.recipe_ingredients.each do |recipe_ingredient|
          shopping_list_ingredient = shopping_list
                                     .shopping_list_ingredients
                                     .where(quantity: recipe_ingredient.quantity,
                                            ingredient_id: recipe_ingredient.ingredient.id)
                                     .first
          shopping_list_ingredient&.destroy
        end
      end

      recipe_plan
    end
  end
end
