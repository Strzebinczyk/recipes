# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'RecipeIngredients', type: :request do
  let(:recipe_ingredient) { create(:recipe_ingredient) }
  let(:user) { create(:user) }

  describe 'GET /recipe_ingredients/new' do
    it 'gets new recipe_ingredient partial' do
      sign_in user
      get new_recipe_ingredient_path(format: :turbo_stream, subaction: :refresh)
      expect(response).to have_http_status(:ok)
    end
  end
end
