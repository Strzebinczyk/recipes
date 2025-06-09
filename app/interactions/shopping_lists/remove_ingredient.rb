# frozen_string_literal: true

module ShoppingLists
  class RemoveIngredient < ActiveInteraction::Base
    object :shopping_list
    string :text

    def execute
      ingredient_name = text.scan(/(\A.+) - .+\z/).last.first
      ingredient = Ingredient.find_by(name: ingredient_name)
      shopping_list_ingredients_array = shopping_list.shopping_list_ingredients.where(ingredient_id: ingredient.id)
      
      shopping_list_ingredients_array.each do |shopping_list_ingredient|
        ShoppingListIngredient.find(shopping_list_ingredient.id).destroy
      end
    end
  end
end
