# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User manages recipe in a meal plan' do
  let(:user) { create(:user) }
  let(:recipe) { create(:recipe) }
  let(:plan) { create(:plan) }

  before do
    Rails.application.load_seed
    login_as(user, scope: :user, run_callbacks: false)
  end

  scenario 'adds recipe', :js do # rubocop:disable RSpec/ExampleLength,RSpec/MultipleExpectations
    visit new_plan_path
    fill_in 'Nazwa', with: 'Tydzień 1'
    click_button 'Zapisz'

    expect(page).to have_content('Tydzień 1')

    visit home_index_path

    expect(page).to have_content('Kurczak w sosie marchewkowym')

    find_all('.recipe-thumbnail').first.hover
    find('.add-to-plan').click

    expect(page).to have_content('Dodaj przepis do planu posiłków')

    click_button 'Zapisz'

    visit plans_path

    expect(page).to have_content('Kurczak w sosie marchewkowym')
  end

  scenario 'removes recipe', :js do # rubocop:disable RSpec/MultipleExpectations,RSpec/ExampleLength
    recipe = plan.recipes.first
    visit plan_path(plan)

    expect(page).to have_content(recipe.name)

    find_all('.btn-secondary').first.click
    accept_confirm
    find('.btn-secondary').click
    accept_confirm

    expect(page).not_to have_content(recipe.name)
  end
end
