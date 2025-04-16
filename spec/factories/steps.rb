# frozen_string_literal: true

FactoryBot.define do
  factory :step do
    recipe
    position {}
    instructions { Faker::TvShows::DrWho.quote }
  end
end
