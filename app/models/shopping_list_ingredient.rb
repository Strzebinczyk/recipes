class ShoppingListIngredient < ApplicationRecord
  belongs_to :shopping_list
  belongs_to :ingredient
  validates :quantity, presence: true

  delegate :name, to: :ingredient, allow_nil: true
end
