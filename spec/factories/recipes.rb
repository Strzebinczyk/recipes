# frozen_string_literal: true

FactoryBot.define do
  factory :recipe do
    user
    name { 'A very nice recipe' }
    serving { 4 }
    ingredients { 'Water, clove of garlic, Maggi' }

    factory :recipe_with_steps do
      transient do
        steps_count { 3 }
      end

      after(:create) do |recipe, evaluator|
        create_list(:step, evaluator.steps_count, recipe: recipe)

        recipe.reload
      end
    end
  end
end
