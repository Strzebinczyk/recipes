# frozen_string_literal: true

module ShoppingLists
  class GenerateIngredientsHash < ActiveInteraction::Base
    object :shopping_list

    def execute
      shopping_list_ingredients_hash = create_shopping_list_ingredient_hash(shopping_list)
      create_ingredients_hash(shopping_list_ingredients_hash)
    end

    def create_shopping_list_ingredient_hash(shopping_list)
      shopping_list.shopping_list_ingredients.each_with_object({}) do |ingredient_item, hash|
        ingredient = ingredient_item.ingredient
        hash[ingredient] ||= []
        hash[ingredient] << ingredient_item
      end
    end

    def create_ingredients_hash(shopping_list_ingredients_hash) # rubocop:disable Metrics/AbcSize,Metrics/MethodLength,Metrics/CyclomaticComplexity
      shopping_list_ingredients_hash.each_with_object({}) do |(ingredient, shopping_list_ingridient_array), hash|
        quantities = shopping_list_ingridient_array.each_with_object({}) do |shopping_list_ingredient, quantities|
          quantities[shopping_list_ingredient.quantity_unit] ||= 0
          quantities[shopping_list_ingredient.quantity_unit] = quantities[shopping_list_ingredient.quantity_unit] +
                                                               (shopping_list_ingredient.quantity_amount || 0)
        end

        quantities_readable = quantities.each_with_object({}) do |(unit, amount), quantities_readable|
          unit = unit_declention(unit, amount)
          amount = amount.to_i if !amount.nil? && (amount % 1).zero?
          quantities_readable[unit] = amount
        end

        hash[ingredient.name] = quantities_readable
      end
    end

    def unit_declention(unit, amount)
      allowed_misc_units = %w[łyżcz łyż szt ząb pusz pęcz szkl garść szczypt kawał opak]

      return unit if unit.in? ['g', 'do smaku', 'ml']
      return nil if unit.nil?

      I18n.t("units.#{unit}", count: amount) if allowed_misc_units.include?(unit)
    end
  end
end
