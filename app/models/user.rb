# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :password, presence: true
  validates :email, uniqueness: true

  has_many :recipes, dependent: :destroy
  has_many :plans, dependent: :destroy
  has_many :shopping_lists, through: :plans
end
