# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Ingredients', type: :request do
  let(:ingredient) { create(:ingredient) }
  let(:user) { create(:user) }

  describe 'GET /ingredients/new' do
    it 'gets new ingredient partial' do
      sign_in user
      get new_ingredient_path(format: :turbo_stream, subaction: :refresh)
      expect(response).to have_http_status(:ok)
    end
  end
end
