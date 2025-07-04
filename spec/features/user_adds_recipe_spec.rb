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
      fill_in 'Nazwa', with: 'Lazanki'
      fill_in 'Liczba porcji', with: 1
      find('.name').fill_in with: 'Pasta'
      find('.quantity').fill_in with: '200g'
      find('.step').fill_in with: 'Boil it'

      click_button 'Prześlij'

      expect(page).to have_content('Boil it')
    end

    scenario 'with multiple steps', :js do # rubocop:disable RSpec/ExampleLength,RSpec/MultipleExpectations
      expect(page).to have_content('Wyloguj')
      fill_in 'Nazwa', with: 'Lazanki'
      fill_in 'Liczba porcji', with: 1
      find('.name').fill_in with: 'Pasta'
      find('.quantity').fill_in with: '200g'

      click_link 'Dodaj instrukcję'

      find_all('.step').first.set('Boil water')
      find_all('.step').last.set('Chop sausage')

      click_button 'Prześlij'

      expect(page).to have_content('Boil water')
      expect(page).to have_content('Chop sausage')
    end

    scenario 'with multiple ingredients', :js do # rubocop:disable RSpec/ExampleLength,RSpec/MultipleExpectations
      expect(page).to have_content('Wyloguj')
      fill_in 'Nazwa', with: 'Lazanki'
      fill_in 'Liczba porcji', with: 1
      find('.step').fill_in with: 'Boil it'

      click_link 'Dodaj składnik'

      find_all('.name')[0].fill_in with: 'Pasta'
      find_all('.quantity')[0].fill_in with: '200g'
      find_all('.name')[1].fill_in with: 'Sauerkraut'
      find_all('.quantity')[1].fill_in with: '100g'

      click_button 'Prześlij'

      expect(page).to have_content('Pasta')
      expect(page).to have_content('200g')
      expect(page).to have_content('Sauerkraut')
      expect(page).to have_content('100g')
    end

    scenario 'with a tag', :js do # rubocop:disable RSpec/ExampleLength
      fill_in 'Nazwa', with: 'Lazanki'
      fill_in 'Liczba porcji', with: 1
      find('.name').fill_in with: 'Pasta'
      find('.quantity').fill_in with: '200g'
      find('.step').fill_in with: 'Boil it'
      js_select('Ciasto')
      click_button 'Prześlij'

      expect(page).to have_content('Ciasto')
    end

    scenario 'with multiple tags', :js do # rubocop:disable RSpec/ExampleLength,RSpec/MultipleExpectations
      fill_in 'Nazwa', with: 'Lazanki'
      fill_in 'Liczba porcji', with: 1
      find('.name').fill_in with: 'Pasta'
      find('.quantity').fill_in with: '200g'
      find('.step').fill_in with: 'Boil it'
      js_select('Ciasto')
      js_select('Wegańskie')

      click_button 'Prześlij'

      expect(page).to have_content('Ciasto')
      expect(page).to have_content('Wegańskie')
    end

    scenario 'with an image' do # rubocop:disable RSpec/ExampleLength
      fill_in 'Nazwa', with: 'Lazanki'
      fill_in 'Liczba porcji', with: 1
      find('.name').fill_in with: 'Pasta'
      find('.quantity').fill_in with: '200g'
      find('.step').fill_in with: 'Boil it'
      page.attach_file('recipe_image', Rails.root.join('app/assets/images/sample.jpg').to_s)

      click_button 'Prześlij'

      expect(page.find('.recipe-image')['src']).to have_content('sample.jpg')
    end
  end

  describe 'With invalid data' do
    scenario 'Without a recipe name' do # rubocop:disable RSpec/ExampleLength
      fill_in 'Liczba porcji', with: 1
      find('.name').fill_in with: 'Pasta'
      find('.quantity').fill_in with: '200g'
      find('.step').fill_in with: 'Boil it'

      click_button 'Prześlij'

      expect(page).to have_content('Pole nazwa nie może być puste')
    end

    scenario 'Without a serving quantity' do # rubocop:disable RSpec/ExampleLength
      fill_in 'Nazwa', with: 'Lazanki'
      find('.name').fill_in with: 'Pasta'
      find('.quantity').fill_in with: '200g'
      find('.step').fill_in with: 'Boil it'

      click_button 'Prześlij'

      expect(page).to have_content('Pole liczba porcji nie może być puste')
    end

    scenario 'Without ingredients' do
      fill_in 'Nazwa', with: 'Lazanki'
      fill_in 'Liczba porcji', with: 1
      find('.step').fill_in with: 'Boil it'

      click_button 'Prześlij'

      expect(page).to have_content('Pole składniki nie może być puste')
    end

    scenario 'Without steps' do # rubocop:disable RSpec/ExampleLength
      fill_in 'Nazwa', with: 'Lazanki'
      fill_in 'Liczba porcji', with: 1
      find('.name').fill_in with: 'Pasta'
      find('.quantity').fill_in with: '200g'

      click_button 'Prześlij'

      expect(page).to have_content('Pole instrukcje nie może być puste')
    end

    scenario 'with an invalid image' do # rubocop:disable RSpec/ExampleLength
      fill_in 'Nazwa', with: 'Lazanki'
      fill_in 'Liczba porcji', with: 1
      find('.name').fill_in with: 'Pasta'
      find('.quantity').fill_in with: '200g'
      find('.step').fill_in with: 'Boil it'
      page.attach_file('recipe_image', Rails.root.join('app/assets/images/add.svg').to_s)

      click_button 'Prześlij'

      expect(page).to have_content('Obraz musi być formatu JPEG lub PNG')
    end
  end
end
