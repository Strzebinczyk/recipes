# frozen_string_literal: true

FactoryBot.define do
  factory :recipe do
    user
    name { 'A very nice recipe' }
    serving { 4 }

    transient do
      ingredients_count { 2 }
      steps_count { 3 }
    end

    after :build do |recipe, evaluator|
      recipe.steps << FactoryBot.build_list(:step, evaluator.steps_count, recipe: nil)
      recipe.ingredients << FactoryBot.build_list(:ingredient, evaluator.ingredients_count, recipe: nil)
    end

    factory :recipe_with_tags do
      transient do
        tags_count { 1 }
      end

      after(:create) do |recipe, evaluator|
        create_list(:tag, evaluator.tags_count, recipes: [recipe])

        recipe.reload
      end
    end
  end
end
