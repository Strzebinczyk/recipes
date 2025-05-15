class ListIngredient < ApplicationRecord
  belongs_to :list
  belongs_to :ingredient
  validates :quantity, presence: true

  delegate :name, to: :ingredient, allow_nil: true
end
