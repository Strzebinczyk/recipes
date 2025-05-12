# frozen_string_literal: true

class Plan < ApplicationRecord
  validates :name, presence: true

  # has_many :recipes, through: :recipe_plans
  # has_many :recipe_plans, dependent: :destroy
  belongs_to :user
end
