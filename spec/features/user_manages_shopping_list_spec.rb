# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User manages shopping list' do
  let(:user) { create(:user) }

  before do
    Rails.application.load_seed
    login_as(user, scope: :user, run_callbacks: false)
    create_plan('Plan 1')
  end

  scenario 'generates pdf', :js do # rubocop:disable RSpec/ExampleLength
    plan = Plan.last
    shopping_list = plan.shopping_list

    add_recipe_to_plan('Kurczak w sosie marchewkowym')
    visit shopping_list_path(shopping_list.id)
    click_button 'Generuj PDF'

    pdf_embed = find('embed')

    expect(pdf_embed[:type]).to eql 'application/pdf'
    page.driver.quit
  end

  scenario 'adds an ingredient', :js do # rubocop:disable RSpec/ExampleLength
    plan = Plan.last
    shopping_list = plan.shopping_list
    visit shopping_list_path(shopping_list.id)

    click_link 'Dodaj składniki'

    find('.name').fill_in with: 'Pasta'
    find('.quantity').fill_in with: '200g'

    click_button 'Zapisz'

    expect(page).to have_content 'Pasta - 200 g'
  end

  scenario 'adds several ingredients', :js do # rubocop:disable RSpec/ExampleLength,RSpec/MultipleExpectations
    plan = Plan.last
    shopping_list = plan.shopping_list
    visit shopping_list_path(shopping_list.id)

    click_link 'Dodaj składniki'
    click_link 'Dodaj składnik'
    click_link 'Dodaj składnik'
    click_link 'Dodaj składnik'

    find_all('.name').first.fill_in with: 'Pasta'
    find_all('.quantity').first.fill_in with: '1/2 g'
    find_all('.name')[1].fill_in with: 'Beetroot'
    find_all('.quantity')[1].fill_in with: '1.5'
    find_all('.name')[2].fill_in with: 'Beetroot'
    find_all('.quantity')[2].fill_in with: '1,5'
    find_all('.name').last.fill_in with: 'Butter'
    find_all('.quantity').last.fill_in with: '1 stick'

    click_button 'Zapisz'

    expect(page).to have_content 'Pasta - 0.5 g'
    expect(page).to have_content 'Beetroot - 3 sztuki'
    expect(page).to have_content 'Butter - 1 stick'
  end
end
