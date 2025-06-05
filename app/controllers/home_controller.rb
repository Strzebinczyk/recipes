# frozen_string_literal: true

class HomeController < ApplicationController
  before_action :load_recipes, only: :index

  def index; end

  private

  def load_recipes
    @pagy, @recent_recipes = pagy(Recipe.order('created_at desc'))
  end
end
