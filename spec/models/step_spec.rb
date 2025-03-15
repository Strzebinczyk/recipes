# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Step, type: :model do
  let(:step1) { create(:step) }

  it 'is valid with valid attributes' do
    expect(step1).to be_valid
  end

  it 'is not valid without instructions' do
    step2 = build(:step, instructions: nil)
    expect(step2).not_to be_valid
  end
end
