# frozen_string_literal: true

class Step < ApplicationRecord
  belongs_to :recipe

  before_create do
    self.position = recipe.steps.last.position + 1
  end
end
