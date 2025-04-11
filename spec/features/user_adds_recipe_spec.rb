# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User adds recipe' do
  let(:user) { create(:user) }
  let(:tag) { create(:tag) }

  before do
    Rails.application.load_seed
    login_as(user, scope: :user, run_callbacks: false)
    visit new_recipe_path
  end

  describe 'With valid data' do
    scenario 'without any steps' do
      fill_in 'Recipe name', with: 'Lazanki'
      fill_in 'Serving', with: 1
      fill_in 'Ingredient list', with: 'Pasta, sauerkraut and sausage'

      click_button 'SUBMIT'

      expect(page).to have_content('Ingredients: Pasta, sauerkraut and sausage')
    end

    scenario 'with one step' do # rubocop:disable RSpec/ExampleLength
      fill_in 'Recipe name', with: 'Lazanki'
      fill_in 'Serving', with: 1
      fill_in 'Ingredient list', with: 'Pasta, sauerkraut and sausage'
      fill_in 'Instructions', with: 'Boil water'

      click_button 'SUBMIT'

      expect(page).to have_content('Boil water')
    end

    scenario 'with multiple steps', :js do # rubocop:disable RSpec/ExampleLength,RSpec/MultipleExpectations
      expect(page).to have_content('Sign out')
      fill_in 'Recipe name', with: 'Lazanki'
      fill_in 'Serving', with: 1
      fill_in 'Ingredient list', with: 'Pasta, sauerkraut and sausage'

      click_link 'Add a step'

      find_all(:field)[-2].set('Boil water')
      find_all(:field).last.set('Chop sausage')

      click_button 'SUBMIT'

      expect(page).to have_content('Boil water')
      expect(page).to have_content('Chop sausage')
    end

    scenario 'with a tag', :js do # rubocop:disable RSpec/ExampleLength
      fill_in 'Recipe name', with: 'Lazanki'
      fill_in 'Serving', with: 1
      fill_in 'Ingredient list', with: 'Pasta, sauerkraut and sausage'
      js_select('Cake')
      click_button 'SUBMIT'

      expect(page).to have_content('Cake')
    end

    scenario 'with multiple tags', :js do # rubocop:disable RSpec/ExampleLength,RSpec/MultipleExpectations
      fill_in 'Recipe name', with: 'Lazanki'
      fill_in 'Serving', with: 1
      fill_in 'Ingredient list', with: 'Pasta, sauerkraut and sausage'
      js_select('Cake')
      js_select('Vegan')

      click_button 'SUBMIT'

      expect(page).to have_content('Cake')
      expect(page).to have_content('Vegan')
    end
  end

  describe 'With invalid data' do
    scenario 'Without a recipe name' do
      fill_in 'Serving', with: 1
      fill_in 'Ingredient list', with: 'Pasta, sauerkraut and sausage'

      click_button 'SUBMIT'

      expect(page).to have_content("Name can't be blank")
    end

    scenario 'Without a serving quantity' do
      fill_in 'Recipe name', with: 'Lazanki'
      fill_in 'Ingredient list', with: 'Pasta, sauerkraut and sausage'

      click_button 'SUBMIT'

      expect(page).to have_content("Serving can't be blank")
    end

    scenario 'Without ingredients' do
      fill_in 'Recipe name', with: 'Lazanki'
      fill_in 'Serving', with: 1

      click_button 'SUBMIT'

      expect(page).to have_content("Ingredients can't be blank")
    end
  end
end
