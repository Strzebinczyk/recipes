class Tag < ApplicationRecord
  has_many :taggings, dependent: :destroy
  has_many :recipes, through: :taggings
end
