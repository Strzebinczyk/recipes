# frozen_string_literal: true

class Ingredient < ApplicationRecord
  validates :name, presence: true
  has_many :recipe_ingredients, dependent: :destroy
  has_many :recipes, through: :recipe_ingredients
  has_many :shopping_list_ingredients, dependent: :destroy
  has_many :shopping_lists, through: :shopping_list_ingredients
end
