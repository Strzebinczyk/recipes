# frozen_string_literal: true

class ShoppingList < ApplicationRecord
  belongs_to :plan
  has_many :shopping_list_ingredients, dependent: :destroy
  has_many :ingredients, through: :shopping_list_ingredients
  accepts_nested_attributes_for :shopping_list_ingredients, allow_destroy: true, reject_if: :all_blank
end
