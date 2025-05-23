# frozen_string_literal: true

class ShoppingListComponent < ViewComponent::Base
  def initialize(shopping_list:, ingredients_hash:)
    super()

    @shopping_list = shopping_list
    @ingredients_printable = create_ingredients_printable(ingredients_hash)
  end

  def create_ingredients_printable(ingredients_hash) # rubocop:disable Metrics/MethodLength
    ingredients_hash.each_with_object([]) do |(ingredient, amounts), array|
      string = "#{ingredient} - "
      string += amounts.map do |unit, amount|
        if unit == 'do smaku'
          unit.to_s
        else
          "#{amount} #{unit}"
        end
      end.join(' + ')
      array << string
    end
  end
end
