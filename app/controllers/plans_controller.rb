# frozen_string_literal: true

class PlansController < ApplicationController
  before_action :authenticate_user!

  def index
    @plans = current_user.plans
  end

  def show
    @plan = Plan.find(params[:id])
  end

  def new
    @plan = Plan.new
  end

  def edit
    @plan = Plan.find(params[:id])
  end

  def create
    @plan = current_user.plans.build(plan_params)

    respond_to do |format|
      if @plan.save
        format.html { redirect_to plans_url, notice: 'Plan was successfully created.' }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    @plan = Plan.find(params[:id])

    respond_to do |format|
      if @plan.update(plan_params)
        format.html { redirect_to plan_url(@plan), notice: 'Plan was successfully updated.' }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @plan = Plan.find(params[:id])
    @plan.destroy

    respond_to do |format|
      format.html { redirect_to plans_url, notice: 'Plan was successfully destroyed.' }
    end
  end

  def new_recipe
    @recipe_plan = RecipePlan.new
  end

  def add_recipe
    @recipe_plan = RecipePlan.build(plan_id: params[:plan_id], recipe_id: params[:recipe_id])

    respond_to do |format|
      if @recipe_plan.save
        format.html { redirect_back fallback_location: root_path, notice: 'RecipePlan was successfully created.' }
      else
        format.html { redirect_back fallback_location: root_path, alert: 'User did not create any plans.' }
      end
    end
  end

  def remove_recipe
    @recipe_plan = RecipePlan.find(params[:id])
    @recipe_plan.destroy

    respond_to do |format|
      format.html { redirect_back fallback_location: root_path, notice: 'RecipePlan was successfully destroyed.' }
    end
  end

  private

  def plan_params
    params.require(:plan).permit(:name, :plan_id, :recipe_id)
  end
end
