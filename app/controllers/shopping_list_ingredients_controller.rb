# frozen_string_literal: true

class ShoppingListIngredientsController < ApplicationController
  def new
    @shopping_list_ingredient = ShoppingListIngredient.new
    @shopping_list = current_user.shopping_lists.find(params[:shopping_list_id])
    respond_to do |format|
      format.turbo_stream
      format.html
    end
  end
end
