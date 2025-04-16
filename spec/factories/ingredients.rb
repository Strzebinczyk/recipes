# frozen_string_literal: true

FactoryBot.define do
  factory :ingredient do
    recipe
    name { 'Carrot' }
    quantity { '1' }
  end
end
