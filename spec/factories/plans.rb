# frozen_string_literal: true

FactoryBot.define do
  factory :plan do
    user
    name { Faker::Restaurant.type }

    transient do
      recipes_count { 2 }
    end

    after(:create) do |plan, evaluator|
      create_list(:recipe, evaluator.recipes_count, plans: [plan])

      plan.reload
    end
  end
end
