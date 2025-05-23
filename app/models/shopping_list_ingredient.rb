# frozen_string_literal: true

class ShoppingListIngredient < ApplicationRecord
  belongs_to :shopping_list
  belongs_to :ingredient

  delegate :name, to: :ingredient, allow_nil: true
end
