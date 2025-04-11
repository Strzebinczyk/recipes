# frozen_string_literal: true

class Recipe < ApplicationRecord
  validates :name, presence: true
  validates :serving, presence: true
  validates :ingredients, presence: true

  belongs_to :user
  has_many :steps, dependent: :destroy
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings
  has_one_attached :image

  accepts_nested_attributes_for :steps, allow_destroy: true, reject_if: :all_blank

  def self.tagged_with(name)
    Tag.find_by!(name: name).recipes
  end

  def tag_list
    tags.map(&:name).join(', ')
  end

  def tag_array
    tags.map(&:name)
  end
end
