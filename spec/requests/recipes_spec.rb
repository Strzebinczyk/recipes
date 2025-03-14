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

  describe 'Post /recipes' do
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
      end
    end
  end
end
