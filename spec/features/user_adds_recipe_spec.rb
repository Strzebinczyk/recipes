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
    scenario 'with one step and one ingredient' do # rubocop:disable RSpec/ExampleLength
      fill_in 'Recipe name', with: 'Lazanki'
      fill_in 'Serving', with: 1
      find('.name').fill_in with: 'Pasta'
      find('.quantity').fill_in with: '200g'
      fill_in 'Instructions', with: 'Boil it'

      click_button 'SUBMIT'

      expect(page).to have_content('Boil it')
    end

    scenario 'with multiple steps', :js do # rubocop:disable RSpec/ExampleLength,RSpec/MultipleExpectations
      expect(page).to have_content('Sign out')
      fill_in 'Recipe name', with: 'Lazanki'
      fill_in 'Serving', with: 1
      find('.name').fill_in with: 'Pasta'
      find('.quantity').fill_in with: '200g'

      click_link 'Add a step'

      find_all(:field)[-2].set('Boil water')
      find_all(:field).last.set('Chop sausage')

      click_button 'SUBMIT'

      expect(page).to have_content('Boil water')
      expect(page).to have_content('Chop sausage')
    end

    scenario 'with multiple ingredients', :js do # rubocop:disable RSpec/ExampleLength,RSpec/MultipleExpectations
      expect(page).to have_content('Sign out')
      fill_in 'Recipe name', with: 'Lazanki'
      fill_in 'Serving', with: 1
      fill_in 'Instructions', with: 'Boil it'

      click_link 'Add an ingredient'

      find_all('.name')[0].fill_in with: 'Pasta'
      find_all('.quantity')[0].fill_in with: '200g'
      find_all('.name')[1].fill_in with: 'Sauerkraut'
      find_all('.quantity')[1].fill_in with: '100g'

      click_button 'SUBMIT'

      expect(page).to have_content('Pasta')
      expect(page).to have_content('200g')
      expect(page).to have_content('Sauerkraut')
      expect(page).to have_content('100g')
    end

    scenario 'with a tag', :js do # rubocop:disable RSpec/ExampleLength
      fill_in 'Recipe name', with: 'Lazanki'
      fill_in 'Serving', with: 1
      find('.name').fill_in with: 'Pasta'
      find('.quantity').fill_in with: '200g'
      fill_in 'Instructions', with: 'Boil it'
      js_select('Cake')
      click_button 'SUBMIT'

      expect(page).to have_content('Cake')
    end

    scenario 'with multiple tags', :js do # rubocop:disable RSpec/ExampleLength,RSpec/MultipleExpectations
      fill_in 'Recipe name', with: 'Lazanki'
      fill_in 'Serving', with: 1
      find('.name').fill_in with: 'Pasta'
      find('.quantity').fill_in with: '200g'
      fill_in 'Instructions', with: 'Boil it'
      js_select('Cake')
      js_select('Vegan')

      click_button 'SUBMIT'

      expect(page).to have_content('Cake')
      expect(page).to have_content('Vegan')
    end

    scenario 'with an image' do # rubocop:disable RSpec/ExampleLength
      fill_in 'Recipe name', with: 'Lazanki'
      fill_in 'Serving', with: 1
      find('.name').fill_in with: 'Pasta'
      find('.quantity').fill_in with: '200g'
      fill_in 'Instructions', with: 'Boil it'
      page.attach_file('recipe_image', Rails.root.join('app/assets/images/sample.jpg').to_s)

      click_button 'SUBMIT'

      expect(page.find('.recipe-image')['src']).to have_content('sample.jpg')
    end
  end

  describe 'With invalid data' do
    scenario 'Without a recipe name' do # rubocop:disable RSpec/ExampleLength
      fill_in 'Serving', with: 1
      find('.name').fill_in with: 'Pasta'
      find('.quantity').fill_in with: '200g'
      fill_in 'Instructions', with: 'Boil it'

      click_button 'SUBMIT'

      expect(page).to have_content("Name can't be blank")
    end

    scenario 'Without a serving quantity' do # rubocop:disable RSpec/ExampleLength
      fill_in 'Recipe name', with: 'Lazanki'
      find('.name').fill_in with: 'Pasta'
      find('.quantity').fill_in with: '200g'
      fill_in 'Instructions', with: 'Boil it'

      click_button 'SUBMIT'

      expect(page).to have_content("Serving can't be blank")
    end

    scenario 'Without ingredients' do
      fill_in 'Recipe name', with: 'Lazanki'
      fill_in 'Serving', with: 1
      fill_in 'Instructions', with: 'Boil it'

      click_button 'SUBMIT'

      expect(page).to have_content("Recipe ingredients can't be blank")
    end

    scenario 'Without steps' do # rubocop:disable RSpec/ExampleLength
      fill_in 'Recipe name', with: 'Lazanki'
      fill_in 'Serving', with: 1
      find('.name').fill_in with: 'Pasta'
      find('.quantity').fill_in with: '200g'

      click_button 'SUBMIT'

      expect(page).to have_content("Steps can't be blank")
    end
  end
end
