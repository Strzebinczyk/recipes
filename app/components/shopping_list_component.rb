# frozen_string_literal: true

class ShoppingListComponent < ViewComponent::Base
  def initialize(shopping_list:) # rubocop:disable Metrics/MethodLength,Metrics/AbcSize
    super()

    @shopping_list = shopping_list
    @ingredients_hash = {}

    @shopping_list.ingredients.distinct.each do |ingredient|
      quantities = {}
      quantities_readable = {}

      ingredient.shopping_list_ingredients.where(@shopping_list.id == :shopping_list_id).find_each do |shopping_list_ingredient| # rubocop:disable Layout/LineLength
        quantities[shopping_list_ingredient.quantity_unit] =
          (quantities[shopping_list_ingredient.quantity_unit] || 0) + shopping_list_ingredient.quantity_amount
      end

      quantities.each do |unit, amount|
        unit = unit_declention(unit, amount)
        amount = amount.to_i if (amount % 1).zero?
        quantities_readable[unit] = amount
      end

      @ingredients_hash[ingredient.name] = quantities_readable
    end
  end

  def unit_declention(unit, amount) # rubocop:disable Metrics/CyclomaticComplexity,Metrics/MethodLength,Metrics/PerceivedComplexity
    allowed_misc_units = [['łyżcz.', 'tsp'], ['łyż.', 'tbsp'], ['szt.', 'unit'], ['ząb.', 'clove'], ['pusz.', 'can'],
                          ['pęcz.', 'bunch'], ['szkl.', 'cup'], ['garść.', 'handful'], ['szczypt', 'pinch'],
                          ['kawał.', 'piece']]

    return unit if unit.in? ['g', 'do smaku', 'ml']
    return nil if unit.nil?

    allowed_misc_units.map do |unit_standardized, declention|
      if unit == unit_standardized
        if amount % 1 != 0
          return I18n.t "units.#{declention}.fraction"
        elsif amount == 1
          return I18n.t "units.#{declention}.one"
        elsif (amount.in? 5..21) || ((amount % 10).in? [0, 1, 5..9])
          return I18n.t "units.#{declention}.5_21"
        else
          return I18n.t "units.#{declention}.2_4"
        end
      end
    end
  end
end
