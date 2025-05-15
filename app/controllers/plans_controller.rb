# frozen_string_literal: true

class PlansController < ApplicationController
  before_action :authenticate_user!

  def index
    @plans = current_user.plans
  end

  def show
    @plan = current_user.plans.find(params[:id])
    @list = @plan.list
  end

  def new
    @plan = Plan.new
    @list = @plan.build_list
  end

  def edit
    @plan = current_user.plans.find(params[:id])
  end

  def create
    @plan = current_user.plans.build(plan_params)

    if @plan.save
      @plan.list.save
      redirect_to plans_url, notice: 'Plan was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @plan = current_user.plans.find(params[:id])

    if @plan.update(plan_params)
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
    @recipe_plan = RecipePlan.new
    @recipe_id = request.url.partition('=').last
    @recipe = Recipe.find(@recipe_id)
  end

  def add_recipe
    @plan = current_user.plans.find(params[:plan_id])
    @recipe_plan = @plan.recipe_plans.build(plan_id: @plan.id, recipe_id: params[:recipe_id])
    @list = @plan.list
    if @recipe_plan.save
      @list.add_recipe(@recipe_plan.recipe)
      redirect_back fallback_location: root_path, notice: 'RecipePlan was successfully created.'
    else
      redirect_back fallback_location: root_path, alert: 'User did not create any plans.'
    end
  end

  def remove_recipe
    @recipe_plan = RecipePlan.find(params[:id])

    if current_user.plans.find(@recipe_plan.plan_id)
      @list.remove_recipe(@recipe_plan.recipe)
      @recipe_plan.destroy
      redirect_back fallback_location: root_path, notice: 'RecipePlan was successfully destroyed.'
    else
      redirect_back fallback_location: root_path, alert: 'This plan does not belong to user.'
    end
  end

  private

  def plan_params
    params.require(:plan).permit(:name, :plan_id, :recipe_id)
  end
end
