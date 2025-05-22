# frozen_string_literal: true

module Plans
  class RemoveRecipe < ActiveInteraction::Base
    string :recipe_plan_id

    def execute # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
      recipe_plan = RecipePlan.find(recipe_plan_id)
      plan = recipe_plan.plan
      recipe = recipe_plan.recipe
      shopping_list = plan.shopping_list

      ActiveRecord::Base.transaction do
        recipe.recipe_ingredients.each do |recipe_ingredient|
          shopping_list_ingredient = shopping_list
                                     .shopping_list_ingredients
                                     .where(quantity_amount: recipe_ingredient.quantity_amount,
                                            quantity_unit: recipe_ingredient.quantity_unit,
                                            ingredient_id: recipe_ingredient.ingredient.id)
                                     .first
          shopping_list_ingredient&.destroy
        end
      end

      recipe_plan
    end
  end
end
