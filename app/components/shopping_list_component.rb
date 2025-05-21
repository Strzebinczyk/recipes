# frozen_string_literal: true

class ShoppingListComponent < ViewComponent::Base
  def initialize(shopping_list:, sl_ingredients_hash:) # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
    super()

    @shopping_list = shopping_list
    @ingredients_hash = {}

    sl_ingredients_hash.each do |ingredient, sl_ingr_array|
      quantities = {}
      quantities_readable = {}

      sl_ingr_array.each do |shopping_list_ingredient|
        quantities[shopping_list_ingredient.quantity_unit] = (quantities[shopping_list_ingredient.quantity_unit] || 0) +
                                                             shopping_list_ingredient.quantity_amount
      end

      quantities.each do |unit, amount|
        unit = unit_declention(unit, amount)
        amount = amount.to_i if (amount % 1).zero?
        quantities_readable[unit] = amount
      end

      @ingredients_hash[ingredient.name] = quantities_readable
    end
  end

  def unit_declention(unit, amount)
    allowed_misc_units = [['łyżcz.', 'tsp'], ['łyż.', 'tbsp'], ['szt.', 'unit'], ['ząb.', 'clove'], ['pusz.', 'can'],
                          ['pęcz.', 'bunch'], ['szkl.', 'cup'], ['garść.', 'handful'], ['szczypt', 'pinch'],
                          ['kawał.', 'piece'], ['opak.', 'package']]

    return unit if unit.in? ['g', 'do smaku', 'ml']
    return nil if unit.nil?

    allowed_misc_units.map do |unit_standardized, declention|
      next unless unit == unit_standardized

      return I18n.t("units.#{declention}", count: amount)
    end
  end
end
