# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }

  it 'is valid with valid attributes' do
    expect(user).to be_valid
  end

  it 'has a unique email' do
    invalid_user = build(:user, email: user.email)
    expect(invalid_user).not_to be_valid
  end

  it 'is not valid without a password' do
    invalid_user = build(:user, password: nil)
    expect(invalid_user).not_to be_valid
  end

  it 'is not valid without an email' do
    invalid_user = build(:user, email: nil)
    expect(invalid_user).not_to be_valid
  end
end
