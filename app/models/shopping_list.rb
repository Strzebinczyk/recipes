# frozen_string_literal: true

class ShoppingList < ApplicationRecord
  belongs_to :plan
  has_many :shopping_list_ingredients, dependent: :destroy
  has_many :ingredients, through: :shopping_list_ingredients
end
