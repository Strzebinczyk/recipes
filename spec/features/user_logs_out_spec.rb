# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User logs out' do
  let(:user) { create(:user) }

  it 'logs the user out' do
    log_in_with user.email, user.password
    click_link 'Wyloguj'

    expect(page).to have_content('Zaloguj')
  end
end
