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
end
