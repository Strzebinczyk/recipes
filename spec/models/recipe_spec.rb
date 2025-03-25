# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Recipe, type: :model do
  let(:recipe) { create(:recipe) }

  it 'is valid with valid attributes' do
    expect(recipe).to be_valid
  end

  it 'is not valid without a name' do
    recipe = build(:recipe, name: nil)
    expect(recipe).not_to be_valid
  end

  it 'is not valid without a serve quantity' do
    recipe = build(:recipe, serving: nil)
    expect(recipe).not_to be_valid
  end

  it 'is not valid without ingredients' do
    recipe = build(:recipe, ingredients: nil)
    expect(recipe).not_to be_valid
  end
end
