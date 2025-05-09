# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User logs in' do
  let(:user) { create(:user) }

  scenario 'with valid email and password' do
    log_in_with user.email, user.password

    expect(page).to have_content('Wyloguj')
  end

  scenario 'with invalid email' do
    log_in_with 'invalid_email', 'password'

    expect(page).to have_content('Nieprawidłowy E-mail lub hasło.')
  end

  scenario 'with blank password' do
    log_in_with 'valid@example.com', ''

    expect(page).to have_content('Nieprawidłowy E-mail lub hasło.')
  end
end
