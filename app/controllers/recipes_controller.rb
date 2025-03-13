# frozen_string_literal: true

class RecipesController < ApplicationController
  before_action :authenticate_user!, only: %i[new create]
  def index
    @recipes = Recipe.all
  end

  def show
    @recipe = Recipe.find(params[:id])
  end

  def new
    @recipe = Recipe.new
    @recipe.steps.build
  end

  def create
    @recipe = current_user.recipes.build(recipe_params)

    if @recipe.save
      redirect_to @recipe
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @recipe = Recipe.find(params[:id])
  end

  def update
    @recipe = Recipe.find(params[:id])

    if @recipe.update(recipe_params)
      redirect_to @recipe
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def require_login
    redirect_to new_user_session_path unless current_user.logged_in?
  end

  def recipe_params
    params.require(:recipe).permit([:name, :serving, :ingredients, { steps_attributes: %i[id position instructions] }])
  end
end
