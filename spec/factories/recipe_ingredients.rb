# frozen_string_literal: true

FactoryBot.define do
  factory :recipe_ingredient do
    ingredient
    quantity { Faker::Number.decimal(l_digits: 2) }
  end
end
