# frozen_string_literal: true

module Plans
  class AddRecipe < ActiveInteraction::Base
    hash :params, strip: false
    object :user

    def execute # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
      plan = user.plans.find(params[:plan_id])
      recipe_plan = plan.recipe_plans.build(plan_id: plan.id, recipe_id: params[:recipe_id])
      recipe = Recipe.find(params[:recipe_id])
      shopping_list = plan.shopping_list
      ActiveRecord::Base.transaction do
        recipe.recipe_ingredients.each do |recipe_ingredient|
          shopping_list_ingr = shopping_list
                               .shopping_list_ingredients.build(quantity_amount: recipe_ingredient.quantity_amount,
                                                                quantity_unit: recipe_ingredient.quantity_unit,
                                                                ingredient_id: recipe_ingredient.ingredient.id)
          errors.merge!(shopping_list_ingr.errors) unless shopping_list_ingr.save
        end
      end

      errors.merge!(recipe_plan.errors) unless recipe_plan.save
      plan
    end
  end
end
