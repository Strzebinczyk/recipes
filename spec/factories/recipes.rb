# frozen_string_literal: true

FactoryBot.define do
  factory :recipe do
    user
    name { Faker::Food.dish }
    serving { rand(1..20) }

    transient do
      recipe_ingredients_count { 2 }
      steps_count { 3 }
    end

    after :build do |recipe, evaluator|
      recipe.steps << FactoryBot.build_list(:step, evaluator.steps_count, recipe: nil)
      recipe.recipe_ingredients << FactoryBot.build_list(:recipe_ingredient, evaluator.recipe_ingredients_count)
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
