class StepsController < ApplicationController
  def new
    respond_to do |format|
      format.turbo_stream
    end
  end

  def destroy
    @step = Step.find(params[:id])
    @step.destroy
  rescue ActiveRecord::RecordNotFound
    @step = Step.new(id: params[:id])
  ensure
    respond_to do |format|
      format.turbo_stream
    end
  end

  def edit
    @step = Step.find(params[:id])
  end

  def update
    @step = Step.find(params[:id])

    if @step.update(step_params)
      redirect_to @step
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def step_params
    params.require(:step).permit(:id, :position, :instructions)
  end
end
