# frozen_string_literal: true

class ShoppingListsController < ApplicationController
  before_action :authenticate_user!

  def show
    @shopping_list = current_user.shopping_lists.includes(:shopping_list_ingredients, :ingredients).find(params[:id])
    @shopping_list_ingredient = ShoppingListIngredient.new
    @ingredients_hash = ShoppingLists::GenerateIngredientsHash.run(shopping_list: @shopping_list).result
  end

  def update
    @shopping_list = current_user.shopping_lists.find(params[:id])
    outcome = ShoppingLists::Update.run(shopping_list: @shopping_list, params: shopping_list_params)

    if outcome.valid?
      redirect_to shopping_list_url(@shopping_list), notice: 'Shopping list was successfully updated.'
    else
      redirect_back fallback_location: root_path, alert: 'User did not create any shopping list ingredients.',
                    status: :unprocessable_entity
    end
  end

  private

  def shopping_list_params
    params
      .require(:shopping_list)
      .permit([{ shopping_list_ingredients_attributes: %i[id name quantity shopp_id _destroy] }])
  end
end
