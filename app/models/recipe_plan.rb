# frozen_string_literal: true

class RecipePlan < ApplicationRecord
  belongs_to :recipe
  belongs_to :plan

  # delegate :name, to: :plan, allow_nil: true
end
