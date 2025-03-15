# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Recipe, type: :model do
  let(:recipe1) { create(:recipe) }

  it 'is valid with valid attributes' do
    expect(recipe1).to be_valid
  end

  it 'is not valid without a name' do
    recipe2 = build(:recipe, name: nil)
    expect(recipe2).not_to be_valid
  end

  it 'is not valid without a serve quantity' do
    recipe2 = build(:recipe, serving: nil)
    expect(recipe2).not_to be_valid
  end

  it 'is not valid without ingredients' do
    recipe2 = build(:recipe, ingredients: nil)
    expect(recipe2).not_to be_valid
  end
end
