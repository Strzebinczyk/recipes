# frozen_string_literal: true

class ShoppingListsController < ApplicationController
  before_action :authenticate_user!

  def show
    @shopping_list = current_user.shopping_lists.includes(:shopping_list_ingredients, :ingredients).find(params[:id])
  end
end
