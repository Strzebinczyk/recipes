# frozen_string_literal: true

class HomeController < ApplicationController
  before_action :load_recipes, only: :index
  def index; end

  private

  def load_recipes
    @recent_recipes = Recipe.order('created_at desc').limit(5)
  end
end
