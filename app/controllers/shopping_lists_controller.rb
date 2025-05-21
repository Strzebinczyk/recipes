# frozen_string_literal: true

class ShoppingListsController < ApplicationController
  before_action :authenticate_user!

  def show
    current_user.plans.each do |plan|
      if plan.shopping_list.id == params[:id].to_i
        @shopping_list = ShoppingList.includes(:shopping_list_ingredients, :ingredients).find(plan.shopping_list.id)
      end
    end
  end
end
