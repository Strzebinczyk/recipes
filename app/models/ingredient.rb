# frozen_string_literal: true

class Ingredient < ApplicationRecord
  validates :name, presence: true
  has_many :recipe_ingredients, dependent: :destroy
  has_many :recipes, through: :recipe_ingredients
  has_many :list_ingredients, dependent: :destroy
  has_many :lists, through: :list_ingredients
end
