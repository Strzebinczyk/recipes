# frozen_string_literal: true

class ShoppingListsController < ApplicationController
  before_action :authenticate_user!

  def show
    @shopping_list, @ingredients_hash, @shopping_list_ingredients_hash = ShoppingLists::Show.run(user: current_user,
                                                                                                 id: params[:id]).result
  end
end
