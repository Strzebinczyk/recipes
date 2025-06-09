# frozen_string_literal: true

module ShoppingLists
  class UpdateIngredient < ActiveInteraction::Base
    object :shopping_list
    string :ingredient_name
    string :ingredient_quantities
    string :ingredient_name_to_edit

    def execute
      ingredient = Ingredient.find_by(name: ingredient_name_to_edit)
      shopping_list_ingredients_array = shopping_list.shopping_list_ingredients.where(ingredient_id: ingredient.id)

      ActiveRecord::Base.transaction do
        shopping_list_ingredients_array.each do |shopping_list_ingredient|
          ShoppingListIngredient.find(shopping_list_ingredient.id).destroy
        end
        ingredient = Ingredient.find_by(name: ingredient_name) || Ingredient.create(name: ingredient_name)
        shopping_list_ingredient = shopping_list
                                     .shopping_list_ingredients.build(quantity: ingredient_quantities,
                                                                      ingredient_id: ingredient.id)
        errors.merge!(shopping_list_ingredient.errors) unless shopping_list_ingredient.save
      end
    end
  end
end
