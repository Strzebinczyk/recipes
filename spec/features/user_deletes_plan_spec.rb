# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User deletes a meal plan' do
  let(:user) { create(:user) }

  before do
    login_as(user, scope: :user, run_callbacks: false)
    visit new_plan_path
    fill_in 'Nazwa', with: 'Tydzień 1'
    click_button 'Zapisz'
  end

  scenario 'with a valid name' do # rubocop:disable RSpec/MultipleExpectations
    expect(page).to have_content('Tydzień 1')
    click_link 'Usuń'

    expect(page).not_to have_content('Tydzień 1')
  end
end
