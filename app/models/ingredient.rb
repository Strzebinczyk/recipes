class Ingredient < ApplicationRecord
  has_many :recipeIngredients, dependent: :destroy
  has_many :recipes, through: :recipeIngredients
end
