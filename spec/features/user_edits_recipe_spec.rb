# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User edits recipe' do
  let(:user) { create(:user) }
  let(:recipe_with_steps) { create(:recipe_with_steps) }
  let(:recipe_with_tags) { create(:recipe_with_tags) }

  before do
    Rails.application.load_seed
    login_as(user, scope: :user, run_callbacks: false)
    visit edit_recipe_path(recipe_with_steps.id)
  end

  describe 'With valid data' do
    scenario 'with editing multiple steps' do # rubocop:disable RSpec/ExampleLength,RSpec/MultipleExpectations
      find_field('Recipe name').set 'Updated name'
      find_field('Serving').set 10
      find_field('Ingredient list').set 'Updated ingredients'
      find_all(:field)[4].set('First updated instruction')
      find_all(:field)[5].set('Second updated instruction')
      find_all(:field).last.set('Third updated instruction')

      click_button 'SUBMIT'

      expect(page).to have_content('Updated name')
      expect(page).to have_content('Updated ingredients')
      expect(page).to have_content('10')
      expect(page).to have_content('First updated instruction')
      expect(page).to have_content('Second updated instruction')
      expect(page).to have_content('Third updated instruction')
      expect(page).to have_content('Recipe was successfully updated.')
    end

    scenario 'with deleting a step', :js do # rubocop:disable RSpec/MultipleExpectations,RSpec/ExampleLength
      find_all(:link)[3].click
      find_all(:link)[3].click
      find_all(:link)[3].click

      click_button 'SUBMIT'

      expect(page).not_to have_content('First updated instruction')
      expect(page).to have_content('Recipe was successfully updated.')
    end

    scenario 'with adding a step', :js do # rubocop:disable RSpec/MultipleExpectations
      click_link 'Add a step'
      find_all(:field)[-1].set('Additional step')

      click_button 'SUBMIT'

      expect(page).to have_content('Additional step')
      expect(page).to have_content('Recipe was successfully updated.')
    end

    scenario 'with deleting a tag', :js do # rubocop:disable RSpec/MultipleExpectations
      visit edit_recipe_path(recipe_with_tags.id)

      expect(page).to have_content('A tag')

      find('div.ss-value-delete').click

      click_button 'SUBMIT'

      expect(page).not_to have_content('A tag')
    end

    scenario 'with adding a tag', :js do # rubocop:disable RSpec/MultipleExpectations
      js_select('Cake')

      click_button 'SUBMIT'

      expect(page).to have_content('Recipe was successfully updated.')
      expect(page).to have_content('Cake')
    end
  end

  describe 'With invalid data' do
    scenario 'Without a recipe name' do
      find_field('Recipe name').set ''

      click_button 'SUBMIT'

      expect(page).to have_content("Name can't be blank")
    end

    scenario 'Without a serving quantity' do
      find_field('Serving').set ''

      click_button 'SUBMIT'

      expect(page).to have_content("Serving can't be blank")
    end

    scenario 'Without ingredients' do
      find_field('Ingredient list').set ''

      click_button 'SUBMIT'

      expect(page).to have_content("Ingredients can't be blank")
    end

    scenario 'Without an instruction' do
      find_all(:field).last.set('')

      click_button 'SUBMIT'

      expect(page).to have_content("Steps instructions can't be blank")
    end
  end
end
