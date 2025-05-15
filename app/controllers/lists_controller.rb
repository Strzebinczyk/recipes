class ListsController < ApplicationController
  before_action :authenticate_user!

  def show
    @list = List.find(params[:id])
  end

  def add_recipe
  end

  def remove_recipe
  end
end
