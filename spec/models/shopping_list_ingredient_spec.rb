# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ShoppingListIngredient, type: :model do
  let(:plan) { create :plan }
  let(:shopping_list) { create :shopping_list, plan: plan }
  let(:shopping_list_ingredient) { create(:shopping_list_ingredient, shopping_list: shopping_list) }

  it 'is valid with valid attributes' do
    expect(shopping_list_ingredient).to be_valid
  end
end
