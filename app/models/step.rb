# frozen_string_literal: true

class Step < ApplicationRecord
  validates :instructions, presence: true
  belongs_to :recipe

  before_create do
    self.position = recipe.steps.last&.position.to_i + 1
  end

  def self.ransackable_attributes(_auth_object = nil)
    ['instructions']
  end
end
