# frozen_string_literal: true

class RecipesController < ApplicationController
  before_action :authenticate_user!, only: %i[new create edit update destroy]

  def index
    @recipes = params[:tag] ? Recipe.tagged_with(params[:tag]) : Recipe.all.includes(user)
    @tag = params[:tag]
  end

  def show
    @recipe = Recipe.find(params[:id])
  end

  def new
    @recipe = Recipes::New.run!
  end

  def create
    outcome = Recipes::Create.run(user: current_user, params: recipe_params)
    @recipe = outcome.result

    if outcome.valid?
      redirect_to recipe_url(@recipe), notice: 'Recipe was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @recipe = Recipe.find(params[:id])
  end

  def update
    @recipe = Recipe.find(params[:id])
    outcome = Recipes::Update.run(recipe: @recipe, params: recipe_params)

    if outcome.valid?
      redirect_to recipe_url(@recipe), notice: 'Recipe was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @recipe = Recipe.find(params[:id])
    @recipe.destroy

    redirect_to home_index_path, notice: 'Recipe was successfully destroyed.'
  end

  private

  def recipe_params
    params
      .require(:recipe)
      .permit([
                :name,
                :serving,
                :image,
                { tag_ids: [] },
                { recipe_ingredients_attributes: %i[id name quantity _destroy] },
                { steps_attributes: %i[id position instructions _destroy] }
              ])
  end
end
