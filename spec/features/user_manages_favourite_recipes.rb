# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User manages favourite recipes' do
  let(:user) { create(:user) }

  before do
    Rails.application.load_seed
    login_as(user, scope: :user, run_callbacks: false)
  end

  scenario 'adds a recipe to favourites' do # rubocop:disable RSpec/ExampleLength,RSpec/MultipleExpectations
    visit home_index_path

    expect(page).to have_content('Biszkopt bezowy z galaretką')

    find_all('.recipe-thumbnail img').last.hover
    find('.add-to-favourites').click

    visit favourite_recipes_path

    expect(page).to have_content('Ulubione przepisy')
    expect(page).to have_content('Biszkopt bezowy z galaretką')
  end

  scenario 'removes recipe from favourites' do # rubocop:disable RSpec/ExampleLength,RSpec/MultipleExpectations
    add_recipe_to_favourites('Biszkopt bezowy z galaretką')

    visit favourite_recipes_path

    expect(page).to have_content('Ulubione przepisy')
    expect(page).to have_content('Biszkopt bezowy z galaretką')

    find_all('.recipe-thumbnail img').last.hover
    find('.remove-from-favourites').click

    expect(page).to have_content('Ulubione przepisy')
    expect(page).not_to have_content('Biszkopt bezowy z galaretką')
  end
end
