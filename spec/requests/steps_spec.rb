# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Steps', type: :request do
  let(:step) { create(:step) }
  let(:user) { create(:user) }

  describe 'GET /steps/new' do
    it 'gets new step partial' do
      sign_in user
      get new_step_path(format: :turbo_stream, subaction: :refresh)
      expect(response).to have_http_status(:ok)
    end
  end
end
