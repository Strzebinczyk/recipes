# frozen_string_literal: true

class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @pagy, @user_recipes = pagy(@user.recipes)
  end
end
