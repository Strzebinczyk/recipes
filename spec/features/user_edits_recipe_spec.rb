# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User edits recipe' do
  let(:user) { create(:user) }
  let(:recipe) { create(:recipe) }
  let(:recipe_with_tags) { create(:recipe_with_tags) }

  before do
    Rails.application.load_seed
    login_as(user, scope: :user, run_callbacks: false)
    visit edit_recipe_path(recipe.id)
  end

  describe 'With valid data' do
    scenario 'with editing multiple steps' do # rubocop:disable RSpec/ExampleLength,RSpec/MultipleExpectations
      find_field('Recipe name').set 'Updated name'
      find_field('Serving').set 10
      find_all('.name')[0].fill_in with: 'Updated ingredient'
      find_all('.quantity')[0].fill_in with: 'Updated amount'
      find_all(:field)[-3].set('First updated instruction')
      find_all(:field)[-2].set('Second updated instruction')
      find_all(:field).last.set('Third updated instruction')

      click_button 'SUBMIT'

      expect(page).to have_content('Updated name')
      expect(page).to have_content('Updated ingredient')
      expect(page).to have_content('Updated amount')
      expect(page).to have_content('10')
      expect(page).to have_content('First updated instruction')
      expect(page).to have_content('Second updated instruction')
      expect(page).to have_content('Third updated instruction')
    end

    scenario 'with deleting a step', :js do
      find_all(:link)[-2].click
      find_all(:link)[-2].click
      find_all(:link)[-2].click

      click_button 'SUBMIT'

      expect(page).not_to have_content('Lorem ipsum')
    end

    scenario 'with adding a step', :js do
      click_link 'Add a step'
      find_all(:field).last.set('Additional step')

      click_button 'SUBMIT'

      expect(page).to have_content('Additional step')
    end

    scenario 'with deleting a tag', :js do # rubocop:disable RSpec/MultipleExpectations
      visit edit_recipe_path(recipe_with_tags.id)

      expect(page).to have_content('A tag')

      find('div.ss-value-delete').click

      click_button 'SUBMIT'

      expect(page).not_to have_content('A tag')
    end

    scenario 'with adding a tag', :js do
      js_select('Cake')

      click_button 'SUBMIT'

      expect(page).to have_content('Cake')
    end

    scenario 'with adding an image' do
      page.attach_file('recipe_image', Rails.root.join('app/assets/images/sample.jpg').to_s)

      click_button 'SUBMIT'

      expect(page.find('.recipe-image')['src']).to have_content('sample.jpg')
    end

    scenario 'with changing the image', :js do # rubocop:disable RSpec/ExampleLength,RSpec/MultipleExpectations
      page.attach_file('recipe_image', Rails.root.join('app/assets/images/sample2.jpg').to_s)

      click_button 'SUBMIT'

      expect(page.find('.recipe-image')['src']).to have_content('sample2.jpg')

      visit edit_recipe_path(recipe.id)

      find('a#preview-close').click
      page.attach_file('recipe_image', Rails.root.join('app/assets/images/sample.jpg').to_s)

      click_button 'SUBMIT'

      expect(page.find('.recipe-image')['src']).to have_content('sample.jpg')
    end

    scenario 'with deleting the image', :js do # rubocop:disable RSpec/ExampleLength,RSpec/MultipleExpectations
      page.attach_file('recipe_image', Rails.root.join('app/assets/images/sample2.jpg').to_s)

      click_button 'SUBMIT'

      expect(page).to have_selector 'img.recipe-image'

      visit edit_recipe_path(recipe.id)

      find('a#preview-close').click

      click_button 'SUBMIT'

      expect(page).not_to have_selector 'img.recipe-image'
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

    scenario 'Without ingredients', :js do
      find_all('a#delete-ingredient').each(&:click)

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
