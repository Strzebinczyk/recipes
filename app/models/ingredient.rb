# frozen_string_literal: true

class Ingredient < ApplicationRecord
  validates :name, presence: true
  has_many :recipe_ingredients, dependent: :destroy
  has_many :recipes, through: :recipe_ingredients

  def self.ransackable_attributes(_auth_object = nil)
    ['name']
  end
end
