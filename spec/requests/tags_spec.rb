# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Tags', type: :request do
  let(:tag) { create(:tag) }

  describe 'GET /tags/:tag' do
    it 'gets recipes tagged with tag' do
      get tag_path(tag.name)

      expect(response).to have_http_status(:ok)
    end
  end
end
