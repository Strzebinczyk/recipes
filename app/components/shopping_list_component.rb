# frozen_string_literal: true

class ShoppingListComponent < ViewComponent::Base
  def initialize(shopping_list:)
    super()

    @shopping_list = shopping_list
    shopping_list_ingredients_hash = create_shopping_list_ingredient_hash(@shopping_list)
    @ingredients_hash = create_ingredients_hash(shopping_list_ingredients_hash)
  end

  def unit_declention(unit, amount)
    allowed_misc_units = %w[łyżcz łyż szt ząb pusz pęcz szkl garść szczypt kawał opak]

    return unit if unit.in? ['g', 'do smaku', 'ml']
    return nil if unit.nil?

    I18n.t("units.#{unit}", count: amount) if allowed_misc_units.include?(unit)
  end

  def create_shopping_list_ingredient_hash(shopping_list)
    shopping_list.shopping_list_ingredients.each_with_object({}) do |ingredient_item, hash|
      ingredient = ingredient_item.ingredient
      hash[ingredient] ||= []
      hash[ingredient] << ingredient_item
    end
  end

  def create_ingredients_hash(shopping_list_ingredients_hash) # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
    ingredients_hash = {}

    shopping_list_ingredients_hash.each do |ingredient, shopping_list_ingridient_array|
      quantities = {}
      quantities_readable = {}

      shopping_list_ingridient_array.each do |shopping_list_ingredient|
        quantities[shopping_list_ingredient.quantity_unit] = (quantities[shopping_list_ingredient.quantity_unit] || 0) +
                                                             shopping_list_ingredient.quantity_amount
      end

      quantities.each do |unit, amount|
        unit = unit_declention(unit, amount)
        amount = amount.to_i if (amount % 1).zero?
        quantities_readable[unit] = amount
      end

      ingredients_hash[ingredient.name] = quantities_readable
    end

    ingredients_hash
  end
end
