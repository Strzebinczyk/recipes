# frozen_string_literal: true

class ShoppingListIngredient < ApplicationRecord
  belongs_to :shopping_list
  belongs_to :ingredient

  delegate :name, to: :ingredient, allow_nil: true
  before_validation :split_quantity

  def split_quantity # rubocop:disable Metrics/AbcSize,Metrics/MethodLength,Metrics/CyclomaticComplexity
    return if quantity.nil?

    quantity = self.quantity.strip
    quantity_amount = case quantity
                      when %r{^\d*/\d*}
                        quantity.split('/')[0].to_f / quantity.split('/')[1].to_i
                      when /^\d*[.]\d*/
                        quantity[/^\d*[.]\d*/].to_f
                      when /^\d*,\d*/
                        quantity.split(',')[0].to_i + (quantity.split(',')[1].to_f / 10)
                      else
                        quantity[/^\d*/]
                      end
    self.quantity_amount = quantity_amount.to_f unless quantity_amount == ''
    self.quantity_amount = nil if quantity_amount == ''
    quantity_unit = quantity[/([a-z]|ł)+.*/]
    quantity_unit = quantity_unit.strip unless quantity_unit.nil?
    self.quantity_unit = standardize_quantity_unit(quantity_unit)
  end
end

private

def standardize_quantity_unit(unit)
  acceptable_matches = [[/łyżecz.*/, 'łyżcz'], [/łyż.*/, 'łyż'], [/szt.*/, 'szt'], [/ząb.*/, 'ząb'],
                        [/pusz.*/, 'pusz'], [/pęcz.*/, 'pęcz'], [/szkl.*/, 'szkl'], [/garś.*/, 'garść'],
                        [/szcz.*/, 'szczypt'], [/kawał.*/, 'kawał'], [/opak.*/, 'opak']]
  return unit if unit.in? ['g', 'do smaku', 'ml']
  return nil if unit.nil? || unit == ''

  acceptable_matches.map do |match, abbr|
    return abbr if unit =~ match
  end
  unit
end
