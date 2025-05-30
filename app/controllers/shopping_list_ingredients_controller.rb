class ShoppingListIngredientsController < ApplicationController
  def new
    @shopping_list_ingredient = ShoppingListIngredient.new
    @shopping_list = current_user.shopping_lists.find(params[:shopping_list_id])
    respond_to do |format|
      format.turbo_stream
      format.html
    end
  end

  def create
    outcome = ShoppingListIngredients::Create.run(params: shopping_list_ingredient_params, user: current_user)
    @shopping_list_ingredient = outcome.result
    @shopping_list = current_user.shopping_lists.find(params[:shopping_list_id])

    if outcome.valid?
      redirect_to shopping_list_path(@shopping_list),
                  notice: 'Ingredient successfully added to shopping list.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def shopping_list_ingredient_params
    params.permit(%i[name quantity shopping_list_id authenticity_token commit])
  end
end
