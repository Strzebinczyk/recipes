# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User logs in' do
  scenario 'with valid email and password' do
    user1 = create(:user)
    log_in_with user1.email, user1.password

    expect(page).to have_content('Sign out')
  end

  scenario 'with invalid email' do
    log_in_with 'invalid_email', 'password'

    expect(page).to have_content('Invalid Email or password.')
  end

  scenario 'with blank password' do
    log_in_with 'valid@example.com', ''

    expect(page).to have_content('Invalid Email or password.')
  end
end
