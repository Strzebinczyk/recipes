# frozen_string_literal: true

class ShoppingListComponent < ViewComponent::Base
  def initialize(shopping_list:) # rubocop:disable Metrics/MethodLength
    super()

    @shopping_list = shopping_list
    @ingredients_hash = {}

    @shopping_list.ingredients.distinct.each do |ingredient|
      quantities = []
      ingredient.shopping_list_ingredients.where(@shopping_list.id == :shopping_list_id).find_each do |shopping_list_ingredient|
        quantities.append(shopping_list_ingredient.quantity)
      end
      quantities = recalculate(quantities: quantities)
      @ingredients_hash[ingredient.name] = quantities
    end
  end

  def recalculate(quantities:) # rubocop:disable Metrics/AbcSize,Metrics/CyclomaticComplexity,Metrics/MethodLength,Metrics/PerceivedComplexity
    quantities_recalculated = []
    count_hash = { 'g' => 0, 'ml' => 0, 'no unit' => 0 }
    conversion_table = [[%w[g gram gramy gramów], %w[kg kilo kilogram kilogramy kilogramów], 1000],
                        [%w[g gram gramy gramów], %w[dkg deko dag dekagram dekagramy dekagramów], 10],
                        [%w[ml mil mililitr mililitrów], %w[l litr litry litrów], 1000],
                        [%w[ml mil mililitr mililitrów], %w[dl decylitr decylitry decylitrów], 100]]

    quantities.each do |quantity| # rubocop:disable Metrics/BlockLength
      quantity = quantity.strip.downcase

      if quantity == 'do smaku'
        quantities_recalculated.append 'do smaku' unless quantities_recalculated.include? 'do smaku'
        next
      end

      amount = if quantity =~ (%r{\d*/\d*})
                 quantity.split('/')[0].to_f / quantity.split('/')[1].to_i
               elsif quantity =~ (/\d*[.]\d*/)
                 quantity[/\d*[.]\d*/].to_f
               elsif quantity =~ (/\d*,\d*/)
                 quantity.split(',')[0].to_1 + (quantity.split(',')[1].to_f / 10)
               else
                 quantity[/\d*/]
               end

      unit = quantity[/([a-z]|ł)+.*/]
      unit = unit.strip unless unit.nil?

      if unit.nil?
        count_hash['no unit'] = (count_hash['no unit'] || 0) + amount.to_f
      elsif conversion_table.flatten.include? unit
        conversion_table.each do |record|
          if record[1].include? unit
            amount *= record[2]
            unit = record[0][0]
            count_hash[unit] = (count_hash[unit] || 0) + amount.to_f
            break
          elsif record[0].include? unit
            unit = record[0][0]
            count_hash[unit] = (count_hash[unit] || 0) + amount.to_f
            break
          end
        end
      else
        count_hash[unit] = (count_hash[unit] || 0) + amount.to_f
      end
    end

    count_hash.each do |key, value|
      value = value.to_i if (value % 1).zero?
      if value.zero?
        next
      elsif key == 'no unit'
        quantities_recalculated.append(value.to_s)
      else
        quantities_recalculated.append("#{value} #{key}")
      end
    end

    quantities_recalculated
  end
end
