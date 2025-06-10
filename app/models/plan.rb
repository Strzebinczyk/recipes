# frozen_string_literal: true

class Plan < ApplicationRecord
  validates :name, presence: true, length: { maximum: 60 }

  has_many :recipe_plans, dependent: :destroy
  has_many :recipes, through: :recipe_plans
  has_one :shopping_list, dependent: :destroy
  belongs_to :user
end
