# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FavouriteRecipe, type: :model do
  let(:favourite_recipe) { create(:favourite_recipe) }

  it 'is valid with valid attributes' do
    expect(favourite_recipe).to be_valid
  end
end
