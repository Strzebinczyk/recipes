# frozen_string_literal: true

class ShoppingListComponent < ViewComponent::Base
  def initialize(shopping_list:) # rubocop:disable Metrics/MethodLength
    super()

    @shopping_list = shopping_list
    @ingredients_hash = {}

    @shopping_list.ingredients.distinct.each do |ingredient|
      quantities = {}
      quantities_readable = {}

      ingredient.shopping_list_ingredients.where(@shopping_list.id == :shopping_list_id).find_each do |shopping_list_ingredient|
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

  def unit_declention(unit, amount)
    if unit.in? ['g', 'do smaku', 'ml', nil]
      unit
    elsif unit == 'łyżcz.'
      if amount % 1 != 0
        I18n.t 'units.tsp.fraction'
      elsif amount == 1
        I18n.t 'units.tsp.one'
      elsif (amount.in? 5..21) || ((amount % 10).in? [0, 1, 5..9])
        I18n.t 'units.tsp.5_21'
      else
        I18n.t 'units.tsp.2_4'
      end
    elsif unit == 'łyż.'
      if amount % 1 != 0
        I18n.t 'units.tbsp.fraction'
      elsif amount == 1
        I18n.t 'units.tbsp.one'
      elsif (amount.in? 5..21) || ((amount % 10).in? [0, 1, 5..9])
        I18n.t 'units.tbsp.5_21'
      else
        I18n.t 'units.tbsp.2_4'
      end
    elsif unit == 'szt.'
      if amount % 1 != 0
        I18n.t 'units.unit.fraction'
      elsif amount == 1
        I18n.t 'units.unit.one'
      elsif (amount.in? 5..21) || ((amount % 10).in? [0, 1, 5..9])
        I18n.t 'units.unit.5_21'
      else
        I18n.t 'units.unit.2_4'
      end
    elsif unit == 'ząb.'
      if amount % 1 != 0
        I18n.t 'units.clove.fraction'
      elsif amount == 1
        I18n.t 'units.clove.one'
      elsif (amount.in? 5..21) || ((amount % 10).in? [0, 1, 5..9])
        I18n.t 'units.clove.5_21'
      else
        I18n.t 'units.clove.2_4'
      end
    elsif unit == 'pusz.'
      if amount % 1 != 0
        I18n.t 'units.can.fraction'
      elsif amount == 1
        I18n.t 'units.can.one'
      elsif (amount.in? 5..21) || ((amount % 10).in? [0, 1, 5..9])
        I18n.t 'units.can.5_21'
      else
        I18n.t 'units.can.2_4'
      end
    elsif unit == 'pęcz.'
      if amount % 1 != 0
        I18n.t 'units.bunch.fraction'
      elsif amount == 1
        I18n.t 'units.bunch.one'
      elsif (amount.in? 5..21) || ((amount % 10).in? [0, 1, 5..9])
        I18n.t 'units.bunch.5_21'
      else
        I18n.t 'units.bunch.2_4'
      end
    elsif unit == 'szkl.'
      if amount % 1 != 0
        I18n.t 'units.cup.fraction'
      elsif amount == 1
        I18n.t 'units.cup.one'
      elsif (amount.in? 5..21) || ((amount % 10).in? [0, 1, 5..9])
        I18n.t 'units.cup.5_21'
      else
        I18n.t 'units.cup.2_4'
      end
    elsif unit == 'garść.'
      if amount % 1 != 0
        I18n.t 'units.handful.fraction'
      elsif amount == 1
        I18n.t 'units.handful.one'
      elsif (amount.in? 5..21) || ((amount % 10).in? [0, 1, 5..9])
        I18n.t 'units.handful.5_21'
      else
        I18n.t 'units.handful.2_4'
      end
    elsif unit == 'szczypt'
      if amount % 1 != 0
        I18n.t 'units.pinch.fraction'
      elsif amount == 1
        I18n.t 'units.pinch.one'
      elsif (amount.in? 5..21) || ((amount % 10).in? [0, 1, 5..9])
        I18n.t 'units.pinch.5_21'
      else
        I18n.t 'units.pinch.2_4'
      end
    elsif unit == 'kawał.'
      if amount % 1 != 0
        I18n.t 'units.piece.fraction'
      elsif amount == 1
        I18n.t 'units.piece.one'
      elsif (amount.in? 5..21) || ((amount % 10).in? [0, 1, 5..9])
        I18n.t 'units.piece.5_21'
      else
        I18n.t 'units.piece.2_4'
      end
    end
  end
end
