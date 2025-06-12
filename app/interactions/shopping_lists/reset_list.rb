# frozen_string_literal: true

module ShoppingLists
  class ResetList < ActiveInteraction::Base
    object :shopping_list

    def execute # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
      shopping_list_ingredients_array = shopping_list.shopping_list_ingredients.all
      plan_id = shopping_list.plan.id
      recipe_plans = RecipePlan.where(plan_id: plan_id)
      recipe_ingredients = recipe_plans.each_with_object([]) do |recipe_plan, array|
        recipe_plan.recipe.recipe_ingredients.each do |recipe_ingredient|
          array << recipe_ingredient
        end
      end

      ActiveRecord::Base.transaction do
        shopping_list_ingredients_array.each do |shopping_list_ingredient|
          ShoppingListIngredient.find(shopping_list_ingredient.id).destroy
        end

        recipe_ingredients.each do |recipe_ingredient|
          shopping_list_ingredient = shopping_list
                                     .shopping_list_ingredients.build(quantity_amount: recipe_ingredient.quantity_amount, # rubocop:disable Layout/LineLength
                                                                      quantity_unit: recipe_ingredient.quantity_unit,
                                                                      ingredient_id: recipe_ingredient.ingredient.id)
          errors.merge!(shopping_list_ingredient.errors) unless shopping_list_ingredient.save
        end
      end
    end
  end
end
