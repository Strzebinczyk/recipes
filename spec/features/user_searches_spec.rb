# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User searches' do
  before do
    Rails.application.load_seed
    visit home_index_path
  end

  scenario 'by recipe name' do
    find('.search').fill_in with: 'Leczo'

    click_button 'Szukaj'

    expect(page).to have_content('Leczo z ciecierzycą')
  end

  scenario 'by tag' do
    find('.search').fill_in with: 'na imprezę'

    click_button 'Szukaj'

    expect(page).to have_content('Bułeczki drożdżowe z masełkami')
  end

  scenario 'by ingredient' do
    find('.search').fill_in with: 'czosnek'

    click_button 'Szukaj'

    expect(page).to have_content('Makaron dyniowy z soczewicą')
  end
end
