class List < ApplicationRecord
  belongs_to :plan
  has_many :list_ingredients, dependent: :destroy
  has_many :ingredients, through: :list_ingredients
end
