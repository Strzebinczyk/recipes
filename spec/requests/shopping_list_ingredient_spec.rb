# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ShoppingListIngredients', type: :request do
  let(:user) { create(:user) }
  let(:plan) { create(:plan, user: user) }
  let(:shopping_list) { create(:shopping_list, plan: plan) }

  describe 'GET /shopping_list_ingredients/new' do
    it 'gets new shopping list ingredient partial, format html' do
      sign_in user

      get new_shopping_list_ingredient_path(shopping_list_id: shopping_list.id)

      expect(response).to have_http_status(:ok)
    end

    it 'gets new shopping list ingredient partial, format turbo_stream' do
      sign_in user

      get new_recipe_ingredient_path(shopping_list_id: shopping_list.id, format: :turbo_stream, subaction: :refresh)

      expect(response).to have_http_status(:ok)
    end
  end
end
