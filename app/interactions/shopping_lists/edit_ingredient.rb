# frozen_string_literal: true

module ShoppingLists
  class EditIngredient < ActiveInteraction::Base
    object :shopping_list
    string :text

    def execute
      ingredient_name = text.scan(/(\A.+) - .+\z/).last.first
      ingredient_quantities = text.scan(/\A.+ - (.+\z)/).last.first
      [ingredient_name, ingredient_quantities]
    end
  end
end
