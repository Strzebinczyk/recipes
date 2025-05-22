# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RecipeIngredient, type: :model do
  let(:recipe) { create(:recipe) }

  it 'is valid with valid attributes' do
    expect(recipe.recipe_ingredients.first).to be_valid
  end

  it 'is not valid without quantity' do
    recipe_ingredient = build(:recipe_ingredient, quantity: nil, recipe: recipe)
    expect(recipe_ingredient).not_to be_valid
  end

  describe '#split_quantity' do
    it 'splits quantity string into quantity_amount float and quantity_unit string' do # rubocop:disable RSpec/MultipleExpectations
      recipe_ingredient = create(:recipe_ingredient, quantity: '200g', recipe: recipe)
      quantity_amount = recipe_ingredient.quantity_amount
      quantity_unit = recipe_ingredient.quantity_unit
      expect(quantity_amount).to eq 200.0
      expect(quantity_unit).to eq 'g'
    end
  end
end
