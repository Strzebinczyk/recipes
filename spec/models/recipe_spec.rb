# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Recipe, type: :model do
  let(:recipe) { create(:recipe) }
  let(:recipe_with_tags) { create(:recipe_with_tags) }
  let(:tag) { create(:tag) }

  it 'is valid with valid attributes' do
    expect(recipe).to be_valid
  end

  it 'is valid with tags' do
    expect(recipe_with_tags).to be_valid
  end

  it 'is not valid without a name' do
    recipe = build(:recipe, name: nil)
    expect(recipe).not_to be_valid
  end

  it 'is not valid without a serve quantity' do
    recipe = build(:recipe, serving: nil)
    expect(recipe).not_to be_valid
  end

  describe '#self.tagged_with' do
    it 'returns an array of recipes with a given tag' do
      recipe_with_tags
      result = described_class.tagged_with(tag.name)
      expect(result).to eq [recipe_with_tags]
    end
  end

  describe '#tag_list' do
    it 'produces a tag list of the recipe' do
      result = recipe_with_tags.tag_list
      expect(result).to eq tag.name
    end
  end
end
