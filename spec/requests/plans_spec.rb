# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Plans', type: :request do
  let(:user) { create(:user) }

  describe 'GET /index' do
    it 'gets new plan partial' do
      sign_in user
      get new_plan_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST /plans' do
    context 'when user is authenticated' do
      before do
        sign_in user
      end

      it 'creates plan successfully' do # rubocop:disable RSpec/ExampleLength,RSpec/MultipleExpectations
        post plans_path, params: { plan: {
          name: 'A name'
        } }
        plan = Plan.last

        expect(plan).to be_present
        expect(plan.name).to eq('A name')
        expect(response).to redirect_to(plans_path)
      end
    end
  end
end
