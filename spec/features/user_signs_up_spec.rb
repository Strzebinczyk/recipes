# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User signs up' do
  scenario 'with valid email and password' do
    sign_up_with 'valid@example.com', 'username', 'password'

    expect(page).to have_content('Wyloguj')
  end

  scenario 'with invalid email' do
    sign_up_with 'invalid_email', 'username', 'password'

    expect(page).to have_content('Zaloguj')
  end

  scenario 'with blank username' do
    sign_up_with 'valid@example.com', '', 'password'

    expect(page).to have_content('Zaloguj')
  end

  scenario 'with blank password' do
    sign_up_with 'valid@example.com', 'username', ''

    expect(page).to have_content('Zaloguj')
  end
end
