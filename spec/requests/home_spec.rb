# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Homes', type: :request do
  describe 'GET /index' do
    it 'should get index' do
      get home_index_path
      assert_response :success
    end
  end
end
