# frozen_string_literal: true

class Recipe < ApplicationRecord
  belongs_to :user
  has_many :steps, dependent: :destroy
end
