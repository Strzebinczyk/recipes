# frozen_string_literal: true

FactoryBot.define do
  factory :favourite_recipe do
    user
    recipe
  end
end
