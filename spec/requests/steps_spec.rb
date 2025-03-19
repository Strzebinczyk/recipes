# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Steps', type: :request do
  let(:step) { create(:step) }
  let(:recipe) { create(:recipe) }
  let(:user) { create(:user) }

  describe 'GET /steps/new' do
    it 'gets new step partial' do
      sign_in user
      get new_step_path(format: :turbo_stream)
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'delete /steps' do
    context 'when user is authenticated' do
      before do
        sign_in user
      end

      it 'delete step successfully' do
        delete step_path(step.id, format: :turbo_stream)

        expect(response).to have_http_status(:ok)
      end

      it 'does not delete step when step id is not found' do
        delete step_path(2, format: :turbo_stream)
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when user is not authenticated' do
      it 'does not delete step' do
        delete step_path(step.id, format: :turbo_stream)

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
