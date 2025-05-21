# frozen_string_literal: true

class ShoppingListsController < ApplicationController
  before_action :authenticate_user!

  def show
    @shopping_list = ShoppingList.find(params[:id])
    @sl_ingredients_hash = {}
    @shopping_list.ingredients.distinct.each do |ingr|
      ingr.shopping_list_ingredients.where(@shopping_list.id == :shopping_list_id).find_each do |shopping_list_ingr|
        @sl_ingredients_hash[ingr] = (@sl_ingredients_hash[ingr] || []).append(shopping_list_ingr)
      end
    end
  end
end
