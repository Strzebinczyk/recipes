# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :password, presence: true, length: { maximum: 60 }
  validates :email, uniqueness: true, length: { maximum: 60 }
  validates :username, uniqueness: true, length: { minimum: 1, maximum: 60 }

  has_many :recipes, dependent: :destroy
  has_many :plans, dependent: :destroy
  has_many :shopping_lists, through: :plans
  has_many :favourite_recipes, dependent: :destroy
  has_many :favourites, through: :favourite_recipes, source: :recipe
end
