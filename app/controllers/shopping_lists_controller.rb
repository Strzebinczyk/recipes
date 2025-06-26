# frozen_string_literal: true

class ShoppingListsController < ApplicationController
  before_action :authenticate_user!

  def show
    @shopping_list = current_user.shopping_lists.includes(:shopping_list_ingredients, :ingredients).find(params[:id])
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

  def edit_ingredient
    @shopping_list = current_user.shopping_lists.find(params[:id])
    outcome = ShoppingLists::EditIngredient.run(shopping_list: @shopping_list, text: params[:ingredient_printable])
    @ingredient_name, @ingredient_quantities = outcome.result
    respond_to do |format|
      format.turbo_stream
    end
  end

  def update_ingredient # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
    @shopping_list = current_user.shopping_lists.find(params[:id])
    outcome = ShoppingLists::UpdateIngredient.run(shopping_list: @shopping_list,
                                                  ingredient_name: params[:ingredient_name],
                                                  ingredient_quantities: params[:ingredient_quantities],
                                                  ingredient_name_to_edit: params[:ingredient_name_to_edit])

    if outcome.valid?
      redirect_to shopping_list_url(@shopping_list), notice: 'Ingredient was successfully updated.'
    else
      redirect_back fallback_location: root_path, alert: 'User did not update any shopping list ingredients.',
                    status: :unprocessable_entity
    end
  end

  def remove_ingredient
    @shopping_list = current_user.shopping_lists.find(params[:id])
    outcome = ShoppingLists::RemoveIngredient.run(shopping_list: @shopping_list, text: params[:ingredient_printable])

    if outcome.valid?
      redirect_to shopping_list_url(@shopping_list), notice: 'Ingredient was successfully deleted.'
    else
      redirect_back fallback_location: root_path, alert: 'User did not delete any shopping list ingredients.',
                    status: :unprocessable_entity
    end
  end

  def reset_list
    @shopping_list = current_user.shopping_lists.find(params[:id])
    outcome = ShoppingLists::ResetList.run(shopping_list: @shopping_list)

    if outcome.valid?
      redirect_to shopping_list_url(@shopping_list), notice: 'List reset successfull.'
    else
      redirect_back fallback_location: root_path, alert: 'List could not be reset.',
                    status: :unprocessable_entity
    end
  end

  def edit_name
    @shopping_list = current_user.shopping_lists.find(params[:id])
    respond_to do |format|
      format.turbo_stream
    end
  end

  def update_name
    @shopping_list = current_user.shopping_lists.find(params[:id])

    if @shopping_list.update(name: params[:name])
      redirect_to shopping_list_url(@shopping_list), notice: 'List name update successfull.'
    else
      redirect_back fallback_location: root_path, alert: 'List name could not be updated.',
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
