# frozen_string_literal: true

class PlansController < ApplicationController
  before_action :authenticate_user!

  def index
    @plans = current_user.plans
  end

  def show
    @plan = current_user.plans.find(params[:id])
  end

  def new
    @plan = Plan.new
  end

  def edit
    @plan = current_user.plans.find(params[:id])
    respond_to do |format|
      format.turbo_stream
    end
  end

  def create
    outcome = Plans::Create.run(user: current_user, params: plan_params)
    @plan = outcome.result

    if outcome.valid?
      redirect_to plans_url, notice: 'Plan was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @plan = current_user.plans.find(params[:id])

    if @plan.update(name: params[:name])
      redirect_to plan_url(@plan), notice: 'Plan was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @plan = current_user.plans.find(params[:id])
    @plan.destroy

    redirect_to plans_url, notice: 'Plan was successfully destroyed.'
  end

  def new_recipe
    @recipe = Recipe.find(params[:recipe])
  end

  def add_recipe
    outcome = Plans::AddRecipe.run(user: current_user, recipe_id: params[:recipe_id], plan_id: params[:plan_id])
    @plan = outcome.result

    if outcome.valid?
      redirect_back fallback_location: root_path, notice: 'RecipePlan was successfully created.'
    else
      redirect_back fallback_location: root_path, alert: 'User did not create any plans.'
    end
  end

  def remove_recipe
    @recipe_plan = Plans::RemoveRecipe.run(recipe_plan_id: params[:id]).result

    if current_user.plans.find(@recipe_plan.plan_id)
      @recipe_plan.destroy
      redirect_back fallback_location: root_path, notice: 'RecipePlan was successfully destroyed.'
    else
      redirect_back fallback_location: root_path, alert: 'This plan does not belong to user.'
    end
  end

  private

  def plan_params
    params.require(:plan).permit(:name, :plan_id, :recipe_id, :recipe)
  end
end
