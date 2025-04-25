# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Ingredient, type: :model do
  let(:ingredient) { create(:ingredient) }

  it 'is valid with valid attributes' do
    expect(ingredient).to be_valid
  end

  it 'is not valid without name' do
    ingredient = build(:ingredient, name: nil)
    expect(ingredient).not_to be_valid
  end
end
