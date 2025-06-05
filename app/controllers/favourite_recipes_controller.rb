# frozen_string_literal: true

class FavouriteRecipesController < ApplicationController
  before_action :authenticate_user!
  def index
    @pagy, @favourite_recipes = pagy(current_user.favourites.all)
  end

  def create
    @favourite_recipe = current_user.favourite_recipes.create(recipe_id: params[:recipe], user_id: current_user.id)
    redirect_back fallback_location: root_path, notice: 'Favourite recipe was successfully created.'
  end

  def destroy
    @favourite_recipe = current_user.favourite_recipes.find(params[:id])
    @favourite_recipe.destroy
    redirect_back fallback_location: root_path, notice: 'Favourite recipe was successfully created.'
  end
end
