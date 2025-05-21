# frozen_string_literal: true

FactoryBot.define do
  factory :plan do
    user
    name { Faker::Restaurant.type }

    after(:create) do |plan|
      create_list(:shopping_list, 1, plan: plan)
      plan.reload
    end
  end
end
