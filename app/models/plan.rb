# frozen_string_literal: true

class Plan < ApplicationRecord
  validates :name, presence: true

  has_many :recipe_plans, dependent: :destroy
  has_many :recipes, through: :recipe_plans
  belongs_to :user

  accepts_nested_attributes_for :recipe_plans, allow_destroy: true, reject_if: :all_blank
end
