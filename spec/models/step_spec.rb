# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Step, type: :model do
  let(:step) { create(:step) }

  it 'is valid with valid attributes' do
    expect(step).to be_valid
  end

  it 'is not valid without instructions' do
    step = build(:step, instructions: nil)
    expect(step).not_to be_valid
  end
end
