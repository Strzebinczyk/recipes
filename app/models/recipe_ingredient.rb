# frozen_string_literal: true

class RecipeIngredient < ApplicationRecord
  belongs_to :recipe
  belongs_to :ingredient
  validates :quantity, presence: true

  delegate :name, to: :ingredient, allow_nil: true
end
