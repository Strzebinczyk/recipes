# frozen_string_literal: true

class StepsController < ApplicationController
  before_action :authenticate_user!, only: %i[new]

  def new
    respond_to do |format|
      format.turbo_stream
    end
  end
end
