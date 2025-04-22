# frozen_string_literal: true

require_relative '../interactions/recipes/create_recipe'

class RecipesController < ApplicationController
  before_action :authenticate_user!, only: %i[new create edit update destroy]

  def index
    @recipes = params[:tag] ? Recipe.tagged_with(params[:tag]) : Recipe.all
    @tag = params[:tag]
  end

  def show
    @recipe = Recipe.find(params[:id])
  end

  def new
    @recipe = Recipe.new
    @recipe.steps.build
    @recipe.ingredients.build
    @recipe.recipe_ingredients.build
  end

  def create
    @recipe = CreateRecipe.run!(user: current_user, params: recipe_params)

    respond_to do |format|
      if @recipe.save
        format.html { redirect_to recipe_url(@recipe), notice: 'Recipe was successfully created.' }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @recipe = Recipe.find(params[:id])
  end

  def update
    @recipe = Recipe.find(params[:id])

    respond_to do |format|
      if @recipe.update(recipe_params)
        format.html { redirect_to recipe_url(@recipe), notice: 'Recipe was successfully updated.' }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @recipe = Recipe.find(params[:id])
    @recipe.destroy

    respond_to do |format|
      format.html { redirect_to home_index_path, notice: 'Recipe was successfully destroyed.' }
    end
  end

  private

  def require_login
    redirect_to new_user_session_path unless current_user.logged_in?
  end

  def recipe_params
    params
      .require(:recipe)
      .permit([:name, :serving, :image, { tag_ids: [] },
               { recipe_ingredients_attributes: %i[ingredient_id name quantity _destroy] },
               { steps_attributes: %i[id position instructions _destroy] }])
  end
end
