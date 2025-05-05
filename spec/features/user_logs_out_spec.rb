# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User signs out' do
  let(:user) { create(:user) }

  it 'logs the user out' do
    log_in_with user.email, user.password
    click_link 'Wyloguj'

    expect(page).to have_content('Signed out successfully.')
  end
end
