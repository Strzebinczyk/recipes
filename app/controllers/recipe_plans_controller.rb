# frozen_string_literal: true

class RecipePlansController < ApplicationController
  def create
    @recipe_plan = RecipePlan.build(plan_id: params[:plan], recipe_id: params[:recipe])

    respond_to do |format|
      if @recipe_plan.save
        format.html { redirect_back fallback_location: root_path, notice: 'RecipePlan was successfully created.' }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end
end
