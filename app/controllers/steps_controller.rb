class StepsController < ApplicationController
  # def create
  #   @recipe = Recipe.find(params[:article_id])
  #   @step = @recipe.steps.create(step_params)
  # end

  def new
    respond_to do |format|
      format.turbo_stream
    end
  end

  def destroy
    step = Step.find(params[:id])
    step.destroy
  rescue ActiveRecord::RecordNotFound
    step = Step.new(id: params[:id])
  ensure
    respond_to do |format|
      format.turbo_stream
    end
  end

  private

  def step_params
    params.require(:step).permit(:position, :instructions)
  end
end
