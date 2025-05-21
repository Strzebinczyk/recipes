# frozen_string_literal: true

class RecipeIngredient < ApplicationRecord
  belongs_to :recipe
  belongs_to :ingredient
  validates :quantity, presence: true
  validates :quantity_amount,
            format: { with: %r{((\A\d*/\d*)|(\A\d*[.]\d*)|(\A\d*,\d*)|(\A\d*))},
                      message: 'Nieprawidłowa ilość, proszę wpisz ilość w formacie liczbowym' }
  validate :quantity_unit_in_whitelist
  delegate :name, to: :ingredient, allow_nil: true

  before_create :split_quantity

  def quantity_unit_in_whitelist
    return if whitelist_conditions?

    errors.add(:quantity_unit, 'Nieprawidłowa jednostka, dozwolone: g, ml, łyżka, łyżeczka, ząbek, kawałek, puszka,
                                  pęczek, szklanka, sztuka, szczypta, garść, do smaku i brak jednostki')
  end

  def whitelist_conditions? # rubocop:disable Metrics/AbcSize,Metrics/CyclomaticComplexity,Metrics/PerceivedComplexity
    quantity_unit =~ /łyż.*/ || quantity_unit =~ /szt.*/ || quantity_unit =~ /ząb.*/ || quantity_unit =~ /pusz.*/ ||
      quantity_unit =~ /kawał.*/ || quantity_unit =~ /pęcz.*/ || quantity_unit =~ /szkl.*/ ||
      quantity_unit =~ /garś.*/ || quantity_unit =~ /szcz.*/ || quantity_unit == 'g' || quantity_unit == 'ml' ||
      quantity_unit == 'do smaku' || quantity_unit.nil?
  end

  def split_quantity # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
    quantity = self.quantity.strip
    quantity_amount = if quantity =~ (%r{^\d*/\d*})
                        quantity.split('/')[0].to_f / quantity.split('/')[1].to_i
                      elsif quantity =~ (/^\d*[.]\d*/)
                        quantity[/^\d*[.]\d*/].to_f
                      elsif quantity =~ (/^\d*,\d*/)
                        quantity.split(',')[0].to_i + (quantity.split(',')[1].to_f / 10)
                      else
                        quantity[/^\d*/]
                      end
    self.quantity_amount = quantity_amount.to_f
    quantity_unit = quantity[/([a-z]|ł)+.*/]
    quantity_unit = quantity_unit.strip unless quantity_unit.nil?
    self.quantity_unit = standardize_quantity_unit(quantity_unit)
  end
end

def standardize_quantity_unit(unit)
  acceptable_matches = [[/łyżecz.*/, 'łyżcz'], [/łyż.*/, 'łyż'], [/szt.*/, 'szt.'], [/ząb.*/, 'ząb.'],
                        [/pusz.*/, 'pusz.'], [/pęcz.*/, 'pęcz.'], [/szkl.*/, 'szkl.'], [/garś.*/, 'garść.'],
                        [/szcz.*/, 'szczypt.'], [/kawał.*/, 'kawał.']]
  return unit if unit.in? ['g', 'do smaku', 'ml', nil]

  acceptable_matches.map do |match, abbr|
    return abbr if unit =~ (match)
  end
end
