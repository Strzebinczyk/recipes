# frozen_string_literal: true

class Tag < ApplicationRecord
  has_many :taggings, dependent: :destroy
  has_many :recipes, through: :taggings

  def self.ransackable_attributes(_auth_object = nil)
    ['name']
  end
end
