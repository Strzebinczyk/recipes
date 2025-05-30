# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ShoppingLists', type: :request do
  let(:user) { create(:user) }
  let(:plan) { create(:plan, user: user) }
  let(:shopping_list) { create(:shopping_list, plan: plan) }

  describe 'GET /shopping_lists/:id' do
    context 'when user is authenticated' do
      before do
        sign_in user
      end

      it 'gets shopping_list show page' do
        get shopping_list_path(shopping_list)

        expect(response).to have_http_status(:ok)
      end
    end

    context 'when user is not authenticated' do
      it 'redirects to log in page' do # rubocop:disable RSpec/MultipleExpectations
        get shopping_list_path(shopping_list)

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'PUT /shopping_lists/:id' do
    context 'when user is authenticated' do
      before do
        sign_in user
      end

      it 'adds an ingredient in an existing shopping list' do # rubocop:disable RSpec/ExampleLength,RSpec/MultipleExpectations
        put shopping_list_path(shopping_list.id), params: { shopping_list: {
          shopping_list_ingredients_attributes: { ShoppingListIngredient.new.hash => { name: 'Carrot', quantity: '3' } }
        } }

        shopping_list = ShoppingList.last
        ingredient = Ingredient.last
        shopping_list_ingredient = ShoppingListIngredient.last

        expect(ingredient).to be_present
        expect(ingredient.name).to eq('Carrot')
        expect(shopping_list_ingredient.quantity).to eq('3')
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(shopping_list_path(shopping_list))
      end

      it 'does not update shopping list when shopping list id is not found' do
        put shopping_list_path(200), params: { shopping_list: {
          shopping_list_ingredients_attributes: { ShoppingListIngredient.new.hash => { name: 'Carrot', quantity: '3' } }
        } }

        expect(response).to have_http_status(:not_found)
      end

      it 'shopping list not updated when details not provided' do
        put shopping_list_path(shopping_list.id), params: { shopping_list: {} }

        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'when user is not authenticated' do
      it 'does not update shopping list' do # rubocop:disable RSpec/MultipleExpectations
        put shopping_list_path(shopping_list.id), params: { shopping_list: {
          shopping_list_ingredients_attributes: { ShoppingListIngredient.new.hash => { name: 'Carrot', quantity: '3' } }
        } }

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
