# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User manages recipe in a meal plan' do
  let(:user) { create(:user) }
  let(:recipe) { create(:recipe) }
  let(:plan) { create(:plan) }

  before do
    Rails.application.load_seed
    login_as(user, scope: :user, run_callbacks: false)
    visit new_plan_path
    fill_in 'Nazwa', with: 'Tydzień 1'
    click_button 'Zapisz'
  end

  scenario 'adds recipe', :js do # rubocop:disable RSpec/ExampleLength,RSpec/MultipleExpectations
    expect(page).to have_content('Tydzień 1')

    visit home_index_path

    expect(page).to have_content('Biszkopt bezowy z galaretką')

    find_all('.recipe-thumbnail img').last.hover
    find('.add-to-plan').click

    expect(page).to have_content('Dodaj przepis do planu posiłków')

    click_button 'Zapisz'

    visit plans_path

    expect(page).to have_content('Moje plany posiłków')
    expect(page).to have_content('Biszkopt bezowy z galaretką')
  end

  scenario 'removes recipe', :js do # rubocop:disable RSpec/MultipleExpectations,RSpec/ExampleLength
    expect(page).to have_content('Tydzień 1')

    visit home_index_path

    expect(page).to have_content('Biszkopt bezowy z galaretką')

    find_all('.recipe-thumbnail').last.hover
    find('.add-to-plan').click

    expect(page).to have_content('Dodaj przepis do planu posiłków')

    click_button 'Zapisz'

    visit plans_path

    expect(page).to have_content('Biszkopt bezowy z galaretką')

    find_all('.btn-secondary').last.click
    accept_confirm

    expect(page).not_to have_content('Biszkopt bezowy z galaretką')
  end
end
