# frozen_string_literal: true

class Recipe < ApplicationRecord
  validates :name, presence: true
  validates :serving, presence: true
  validates :ingredients, presence: true
  validate :acceptable_image

  belongs_to :user
  has_many :steps, dependent: :destroy
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings
  has_one_attached :image, dependent: :destroy

  accepts_nested_attributes_for :steps, allow_destroy: true, reject_if: :all_blank

  attr_accessor :destroy_image

  after_save(:purge_image)

  def self.tagged_with(name)
    Tag.find_by!(name: name).recipes
  end

  def tag_list
    tags.map(&:name).join(', ')
  end

  def tag_array
    tags.map(&:name)
  end

  private

  def purge_image
    return unless :destroy_image == true

    image.purge_later
  end

  def acceptable_image
    return unless image.attached?

    errors.add(:image, 'is too big') unless image.blob.byte_size <= 1.megabyte

    acceptable_types = ['image/jpeg', 'image/png']
    return if acceptable_types.include?(image.content_type)

    errors.add(:image, 'must be a JPEG or PNG')
  end
end
