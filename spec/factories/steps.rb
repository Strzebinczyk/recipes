# frozen_string_literal: true

FactoryBot.define do
  factory :step do
    recipe
    position {}
    instructions do
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.'
    end
  end
end
