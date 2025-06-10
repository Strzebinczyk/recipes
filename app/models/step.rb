# frozen_string_literal: true

class Step < ApplicationRecord
  validates :instructions, presence: true, length: { maximum: 200 }
  belongs_to :recipe
end
