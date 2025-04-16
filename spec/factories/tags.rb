# frozen_string_literal: true

FactoryBot.define do
  factory :tag do
    name { Faker::TvShows::StarTrek.character }
  end
end
