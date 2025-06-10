# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ShoppingLists', type: :request do
  let(:user) { create(:user) }
  let(:plan) { create(:plan, user: user) }
  let(:shopping_list) { create(:shopping_list, plan: plan) }
  let(:shopping_list_ingredient) { create(:shopping_list_ingredient, shopping_list: shopping_list) }

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
    let(:other_plan) { create(:plan) }
    let(:other_shopping_list) { create(:shopping_list, plan: other_plan) }

    context 'when user is authenticated' do # rubocop:disable RSpec/MultipleMemoizedHelpers
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

      it 'shopping list not updated when it does not belong to user' do
        put shopping_list_path(other_shopping_list.id), params: { shopping_list: {
          shopping_list_ingredients_attributes: { ShoppingListIngredient.new.hash => { name: 'Carrot', quantity: '3' } }
        } }

        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when user is not authenticated' do # rubocop:disable RSpec/MultipleMemoizedHelpers
      it 'does not update shopping list' do # rubocop:disable RSpec/MultipleExpectations
        put shopping_list_path(shopping_list.id), params: { shopping_list: {
          shopping_list_ingredients_attributes: { ShoppingListIngredient.new.hash => { name: 'Carrot', quantity: '3' } }
        } }

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'GET shopping_lists/:id/edit_ingredient' do
    context 'when user is authenticated' do
      before do
        sign_in user
      end

      it 'edit ingredient partial is rendered' do
        ingredient_printable = "#{shopping_list_ingredient.name} - #{shopping_list_ingredient.quantity_amount} #{shopping_list_ingredient.quantity_unit}" # rubocop:disable Layout/LineLength
        get edit_ingredient_shopping_list_path(shopping_list, format: :turbo_stream), params: {
          ingredient_printable: ingredient_printable, td_id: ingredient_printable.delete(' '), id: shopping_list.id
        }

        expect(response).to have_http_status(:ok)
      end
    end

    context 'when user is not authenticated' do
      it 'redirects to log in page' do # rubocop:disable RSpec/MultipleExpectations
        get edit_ingredient_shopping_list_path(shopping_list)

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'PATCH /shopping_lists/:id/update_ingredient' do # rubocop:disable RSpec/MultipleMemoizedHelpers
    let(:other_plan) { create(:plan) }
    let(:other_shopping_list) { create(:shopping_list, plan: other_plan) }

    context 'when user is authenticated' do # rubocop:disable RSpec/MultipleMemoizedHelpers
      before do
        sign_in user
      end

      it 'adds an ingredient in an existing shopping list' do # rubocop:disable RSpec/ExampleLength,RSpec/MultipleExpectations
        put shopping_list_path(shopping_list.id), params: { shopping_list: {
          shopping_list_ingredients_attributes: { ShoppingListIngredient.new.hash => { name: 'Carrot', quantity: '3' } }
        } }

        shopping_list = ShoppingList.last
        ingredient = Ingredient.last
        shopping_list_ingredient_id = ShoppingListIngredient.last.id

        put update_ingredient_shopping_list_path(shopping_list.id), params: { ingredient_name: 'Beetroot',
                                                                              ingredient_quantities: '41',
                                                                              ingredient_name_to_edit: 'Carrot' }

        shopping_list = ShoppingList.last
        updated_ingredient = Ingredient.last
        updated_shopping_list_ingredient = ShoppingListIngredient.last

        expect(ingredient).to be_present
        expect(ingredient.name).to eq('Carrot')
        expect(updated_ingredient).to be_present
        expect(updated_ingredient.name).to eq('Beetroot')
        expect(ShoppingListIngredient.exists?(shopping_list_ingredient_id)).to be false
        expect(updated_shopping_list_ingredient).to be_present
        expect(updated_shopping_list_ingredient.quantity).to eq('41')
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(shopping_list_path(shopping_list))
      end

      it 'does not update shopping list when shopping list id is not found' do
        put update_ingredient_shopping_list_path(200), params: { ingredient_name: 'Beetroot',
                                                                 ingredient_quantities: '41',
                                                                 ingredient_name_to_edit: 'Carrot' }

        expect(response).to have_http_status(:not_found)
      end

      it 'shopping list not updated when details not provided' do
        put update_ingredient_shopping_list_path(shopping_list.id), params: {}

        expect(response).to have_http_status(:unprocessable_content)
      end

      it 'shopping list not updated when it does not belong to user' do
        put update_ingredient_shopping_list_path(other_shopping_list.id), params: { ingredient_name: 'Beetroot',
                                                                                    ingredient_quantities: '41',
                                                                                    ingredient_name_to_edit: 'Carrot' }

        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when user is not authenticated' do # rubocop:disable RSpec/MultipleMemoizedHelpers
      it 'does not update shopping list' do # rubocop:disable RSpec/MultipleExpectations,RSpec/ExampleLength
        put shopping_list_path(shopping_list.id), params: { shopping_list: {
          shopping_list_ingredients_attributes: { ShoppingListIngredient.new.hash => { name: 'Carrot', quantity: '3' } }
        } }

        put update_ingredient_shopping_list_path(shopping_list.id), params: { ingredient_name: 'Beetroot',
                                                                              ingredient_quantities: '41',
                                                                              ingredient_name_to_edit: 'Carrot' }

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'DELETE /shopping_lists/:id/remove_ingredient' do
    context 'when user is authenticated' do
      before do
        sign_in user
      end

      it 'deletes element off the list recipe' do # rubocop:disable RSpec/MultipleExpectations,RSpec/ExampleLength
        put shopping_list_path(shopping_list.id), params: { shopping_list: {
          shopping_list_ingredients_attributes: { ShoppingListIngredient.new.hash => { name: 'Carrot', quantity: '3' } }
        } }

        shopping_list_ingredient_id = ShoppingListIngredient.last.id

        delete remove_ingredient_shopping_list_path(shopping_list.id),
               params: { ingredient_printable: 'Carrot - 3 sztuki' }

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to shopping_list_path(shopping_list.id)
        expect(ShoppingListIngredient.exists?(shopping_list_ingredient_id)).to be false
      end
    end

    context 'when user is not authenticated' do
      it 'redirects to log in page' do # rubocop:disable RSpec/ExampleLength,RSpec/MultipleExpectations
        sign_in user

        put shopping_list_path(shopping_list.id), params: { shopping_list: {
          shopping_list_ingredients_attributes: { ShoppingListIngredient.new.hash => { name: 'Carrot', quantity: '3' } }
        } }

        shopping_list_ingredient_id = ShoppingListIngredient.last.id

        sign_out user

        delete remove_ingredient_shopping_list_path(shopping_list.id),
               params: { ingredient_printable: 'Carrot - 3 sztuki' }

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(new_user_session_path)
        expect(ShoppingListIngredient.exists?(shopping_list_ingredient_id)).to be true
      end
    end
  end
end
