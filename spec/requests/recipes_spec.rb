# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Recipes', type: :request do
  let(:recipe) { create(:recipe) }
  let(:user) { create(:user) }

  describe 'GET /recipes/:id' do
    it 'should get recipe show page' do
      get recipe_path(recipe)
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET /recipes/new' do
    it 'should get new recipe page' do
      sign_in user
      get new_recipe_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST /recipes' do
    context 'when user is authenticated' do
      before do
        sign_in user
      end

      it 'creates recipe successfully' do
        post '/recipes', params: { recipe: {
          name: 'Valid recipe',
          serving: 2,
          ingredients: 'Fish and garlic'
        } }

        recipe = Recipe.last
        expect(recipe).to be
        expect(recipe.name).to eq('Valid recipe')
        expect(recipe.serving).to eq(2)
        expect(recipe.ingredients).to eq('Fish and garlic')
        expect(response).to redirect_to(recipe_path(recipe))
      end

      it 'bad request when book data is empty' do
        post '/recipes', params: { recipe: {} }
        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'when user is not authenticated' do
      it 'creates recipe successfully' do
        post '/recipes', params: { recipe: {
          name: 'Valid recipe',
          serving: 2,
          ingredients: 'Fish and garlic'
        } }
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'GET /recipes/:id/edit' do
    it 'should get recipe edit page' do
      sign_in user
      get edit_recipe_path(recipe)
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'PUT /recipes/:id' do
    context 'when user is authenticated' do
      before do
        sign_in user
      end

      it 'updates recipe successfully' do
        put "/recipes/#{recipe.id}", params: { id: recipe.id, recipe: {
          name: 'Updated recipe',
          serving: 10,
          ingredients: 'Garlic and water'
        } }
        recipe = Recipe.last
        expect(recipe).to be
        expect(recipe.name).to eq('Updated recipe')
        expect(recipe.serving).to eq(10)
        expect(recipe.ingredients).to eq('Garlic and water')
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(recipe_path(recipe))
      end

      it 'should not update recipe when recipe id is not found' do
        put '/recipe/2', params: { id: 2, recipe: {
          name: 'Updated recipe',
          serving: 10,
          ingredients: 'Garlic and water'
        } }
        expect(response).to have_http_status(:not_found)
      end

      it 'recipe not updated when details not provided' do
        put "/recipes/#{recipe.id}", params: { id: recipe.id, recipe: {} }
        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'when user is not authenticated' do
      it 'should not update recipe ' do
        put "/recipe/#{recipe.id}", params: { id: recipe.id, recipe: {
          name: 'Updated recipe',
          serving: 10,
          ingredients: 'Garlic and water'
        } }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'delete /recipes' do
    context 'when user is authenticated' do
      before do
        sign_in user
      end

      it 'delete recipe successfully' do
        delete "/recipes/#{recipe.id}"

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(home_index_path)
      end

      it 'should not delete recipe when recipe id is not found' do
        delete '/recipes/2'

        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when user is not authenticated' do
      it 'should not delete recipe ' do
        put "/recipes/#{recipe.id}"

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
