# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User adds a meal plan' do
  let(:user) { create(:user) }

  before do
    login_as(user, scope: :user, run_callbacks: false)
    visit new_plan_path
  end

  scenario 'with a valid name' do
    fill_in 'Nazwa', with: 'Tydzień 1'

    click_button 'Zapisz'

    expect(page).to have_content('Tydzień 1')
  end

  scenario 'with a blank name' do
    click_button 'Zapisz'

    expect(page).to have_content('Pole nazwa nie może być puste')
  end
end
