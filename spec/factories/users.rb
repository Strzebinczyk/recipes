# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { "#{Time.now.to_f}@example.com" }
    password { 'blahblah' }
  end
end
