# frozen_string_literal: true

module ShoppingListIngredients
  class Create < ActiveInteraction::Base
    hash :params, strip: false
    object :user

    def execute # rubocop:disable Metrics/AbcSize
      shopping_list = user.shopping_lists.find(params[:shopping_list_id])
      ingredient = Ingredient.find_by(name: params[:name]) || Ingredient.create(name: params[:name])
      shopping_list_ingredient = shopping_list
                                 .shopping_list_ingredients.build(quantity_amount: params[:quantity],
                                                                  ingredient_id: ingredient.id)
      errors.merge!(shopping_list_ingredient.errors) unless shopping_list_ingredient.save
      shopping_list_ingredient
    end
  end
end
