# frozen_string_literal: true

class Ingredient < ApplicationRecord
  validates :name, presence: true
  validates :quantity, presence: true

  has_many :recipe_ingredients, dependent: :destroy
  has_many :recipes, through: :recipe_ingredients
end
