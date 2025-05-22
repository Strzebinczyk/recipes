# frozen_string_literal: true

FactoryBot.define do
  factory :shopping_list_ingredient do
    ingredient
    quantity_amount { Faker::Number.decimal(l_digits: 2) }
    quantity_unit do
      %w[g ml łyżki łyżeczki ząbka kawałka puszki pęczka szklanki szczypty garści sztuki opakowania].sample
    end
  end
end
