class StepsController < ApplicationController
  def create
    @recipe = Recipe.find(params[:article_id])
    @step = @recipe.steps.create(step_params)
  end

  private

  def step_params
    params.require(:step).permit(:position, :instructions)
  end
end
