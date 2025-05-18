class ShoppingListsController < ApplicationController
  before_action :authenticate_user!

  def show
    @shopping_list = ShoppingList.find(params[:id])
  end
end
