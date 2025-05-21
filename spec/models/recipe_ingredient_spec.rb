# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RecipeIngredient, type: :model do
  let(:recipe) { create(:recipe) }

  it 'is valid with valid attributes' do
    expect(recipe.recipe_ingredients.first).to be_valid
  end

  it 'is not valid without quantity' do
    recipe_ingredient = build(:recipe_ingredient, quantity: nil)
    expect(recipe_ingredient).not_to be_valid
  end
end
