# frozen_string_literal: true

FactoryBot.define do
  factory :recipe_ingredient do
    ingredient
    recipe
  end
end
