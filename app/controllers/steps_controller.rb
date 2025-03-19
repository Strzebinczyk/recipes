# frozen_string_literal: true

class StepsController < ApplicationController
  before_action :authenticate_user!, only: %i[new destroy]
  def new
    respond_to do |format|
      format.turbo_stream
    end
  end

  def destroy
    @step = Step.find(params[:id])
    @step.destroy

    respond_to do |format|
      format.turbo_stream
    end
  end

  private

  def step_params
    params.require(:step).permit(:id, :position, :instructions)
  end
end
