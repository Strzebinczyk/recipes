# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Favourite recipes', type: :request do
  let(:user) { create(:user) }
  let(:recipe) { create(:recipe) }
  let(:favourite_recipe) { create(:favourite_recipe, user: user, recipe: recipe) }

  describe 'GET /favourite_recipes' do
    context 'when user is authenticated' do
      before do
        sign_in user
      end

      it 'gets favourite recipe index page' do
        get favourite_recipes_path
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when user is not authenticated' do
      it 'redirects to log in page' do # rubocop:disable RSpec/MultipleExpectations
        get favourite_recipes_path

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'POST /favourite_recipes' do
    context 'when user is authenticated' do
      before do
        sign_in user
      end

      it 'creates new favourite recipe' do # rubocop:disable RSpec/ExampleLength,RSpec/MultipleExpectations
        post favourite_recipes_path, params: { favourite_recipe: {
          user_id: user.id,
          recipe_id: recipe.id
        } }

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to root_path
      end
    end

    context 'when user is not authenticated' do
      it 'redirects to log in page' do # rubocop:disable RSpec/MultipleExpectations,RSpec/ExampleLength
        post favourite_recipes_path, params: { favourite_recipe: {
          user_id: user.id,
          recipe_id: recipe.id
        } }

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'DELETE /favourite_recipes/:id' do
    context 'when user is authenticated' do
      before do
        sign_in user
      end

      it 'deletes favourite recipe' do # rubocop:disable RSpec/MultipleExpectations
        favourite_recipe_id = favourite_recipe.id
        delete favourite_recipe_path(favourite_recipe_id)

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to root_path
        expect(FavouriteRecipe.exists?(favourite_recipe_id)).to be false
      end
    end

    context 'when user is not authenticated' do
      it 'redirects to log in page' do # rubocop:disable RSpec/MultipleExpectations
        favourite_recipe_id = favourite_recipe.id
        delete favourite_recipe_path(favourite_recipe_id)

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(new_user_session_path)
        expect(FavouriteRecipe.exists?(favourite_recipe_id)).to be true
      end
    end
  end
end
