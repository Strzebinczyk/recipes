# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let(:user1) { create(:user) }

  describe 'GET /users/:id' do
    it 'gets users show page' do
      get user_path(user1)
      expect(response).to have_http_status(:ok)
    end
  end
end
