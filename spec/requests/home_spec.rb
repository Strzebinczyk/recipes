# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Home', type: :request do
  describe 'GET /index' do
    it 'gets index' do
      get home_index_path
      expect(response).to have_http_status(:ok)
    end
  end
end
