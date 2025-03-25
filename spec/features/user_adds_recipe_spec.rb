# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User adds recipe' do
  include Warden::Test::Helpers
  Warden.test_mode!

  let(:user) { create(:user) }

  before do
    login_as(user, scope: :user, run_callbacks: false)
    visit new_recipe_path
  end

  describe 'With valid data' do
    scenario 'without any steps' do
      fill_in 'Recipe name', with: 'Lazanki'
      fill_in 'Serving', with: 1
      fill_in 'Ingredient list', with: 'Pasta, sauerkraut and sausage'
      click_button 'Submit'
      expect(page).to have_content('Recipe was successfully created.')
    end

    scenario 'with one step' do # rubocop:disable RSpec/ExampleLength,RSpec/MultipleExpectations
      fill_in 'Recipe name', with: 'Lazanki'
      fill_in 'Serving', with: 1
      fill_in 'Ingredient list', with: 'Pasta, sauerkraut and sausage'
      fill_in 'Instructions', with: 'Boil water'
      click_button 'Submit'
      expect(page).to have_content('Boil water')
      expect(page).to have_content('Recipe was successfully created.')
    end

    scenario 'with multiple steps', :js do # rubocop:disable RSpec/ExampleLength,RSpec/MultipleExpectations
      expect(page).to have_content('Sign out')
      fill_in 'Recipe name', with: 'Lazanki'
      fill_in 'Serving', with: 1
      fill_in 'Ingredient list', with: 'Pasta, sauerkraut and sausage'
      click_link 'Add a step'
      find_all(:field)[-2].set('Boil water')
      find_all(:field).last.set('Chop sausage')
      click_button 'Submit'
      expect(page).to have_content('Recipe was successfully created.')
      expect(page).to have_content('Boil water')
      expect(page).to have_content('Chop sausage')
    end
  end

  describe 'With invalid data' do
    scenario 'Without a recipe name' do
      fill_in 'Serving', with: 1
      fill_in 'Ingredient list', with: 'Pasta, sauerkraut and sausage'
      click_button 'Submit'
      expect(page).to have_content("Name can't be blank")
    end

    scenario 'Without a serving quantity' do
      fill_in 'Recipe name', with: 'Lazanki'
      fill_in 'Ingredient list', with: 'Pasta, sauerkraut and sausage'
      click_button 'Submit'
      expect(page).to have_content("Serving can't be blank")
    end

    scenario 'Without ingredients' do
      fill_in 'Recipe name', with: 'Lazanki'
      fill_in 'Serving', with: 1
      click_button 'Submit'
      expect(page).to have_content("Ingredients can't be blank")
    end
  end
end
