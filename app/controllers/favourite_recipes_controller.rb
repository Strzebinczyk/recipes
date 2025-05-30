# frozen_string_literal: true

class FavouriteRecipesController < ApplicationController
  def index
    @favourite_recipes = current_user.favourites.all
  end

  def create
    @favourite_recipes = current_user.favourite_recipes.create(recipe_id: params[:recipe], user_id: current_user.id)
  end
end
