# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User manages shopping list' do
  let(:user) { create(:user) }

  before do
    Rails.application.load_seed
    login_as(user, scope: :user, run_callbacks: false)
    create_plan('Plan 1')
  end

  scenario 'generates pdf', :js do
    plan = Plan.last
    shopping_list = plan.shopping_list

    add_recipe_to_plan('Kurczak w sosie marchewkowym')
    visit shopping_list_path(shopping_list.id)
    click_link 'Generuj PDF'

    page.status_code.must_equal 200
  end
end
