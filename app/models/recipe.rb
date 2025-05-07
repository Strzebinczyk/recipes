# frozen_string_literal: true

class Recipe < ApplicationRecord
  validates :name, presence: true
  validates :serving, presence: true
  validates :recipe_ingredients, presence: true
  validates :steps, presence: true
  validate :acceptable_image

  belongs_to :user
  has_many :steps, dependent: :destroy
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings
  has_many :recipe_ingredients, dependent: :destroy
  has_many :ingredients, through: :recipe_ingredients
  has_one_attached :image, dependent: :destroy

  accepts_nested_attributes_for :steps, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :recipe_ingredients, allow_destroy: true, reject_if: :all_blank

  def self.tagged_with(name)
    Tag.find_by!(name: name).recipes
  end

  def tag_list
    tags.map(&:name).join(', ')
  end

  def tag_array
    tags.map(&:name)
  end

  def self.ransackable_attributes(_auth_object = nil)
    ['name']
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[ingredients steps tags]
  end

  private

  def acceptable_image
    return unless image.attached?

    errors.add(:image, 'is too big') unless image.blob.byte_size <= 1.megabyte

    acceptable_types = ['image/jpeg', 'image/png']
    return if acceptable_types.include?(image.content_type)

    errors.add(:image, 'must be a JPEG or PNG')
  end
end
