# frozen_string_literal: true

class Step < ApplicationRecord
  validates :instructions, presence: true
  belongs_to :recipe
end
