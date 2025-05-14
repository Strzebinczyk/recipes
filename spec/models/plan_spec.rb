# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Plan, type: :model do
  let(:plan) { create(:plan) }

  it 'is valid with valid attributes' do
    expect(plan).to be_valid
  end

  it 'is not valid without name' do
    plan = build(:plan, name: nil)
    expect(plan).not_to be_valid
  end
end
