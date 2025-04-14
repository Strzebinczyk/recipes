# frozen_string_literal: true

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
  end

  def create
    @recipe = current_user.recipes.build(recipe_params)

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

  def delete_image
    @recipe = Recipe.find(params[:id])
    @recipe.image.purge_later
    redirect_back fallback_location: root_path
  end

  private

  def require_login
    redirect_to new_user_session_path unless current_user.logged_in?
  end

  def recipe_params
    params
      .require(:recipe)
      .permit([:name, :serving, :ingredients, { steps_attributes: %i[id position instructions _destroy] },
               { tag_ids: [] }, :image])
  end
end
