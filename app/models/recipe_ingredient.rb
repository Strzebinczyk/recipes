# frozen_string_literal: true

class RecipeIngredient < ApplicationRecord
  belongs_to :recipe
  belongs_to :ingredient
  validates :quantity, presence: true, length: { maximum: 60 }
  validates :quantity,
            format: { with: /\A((\d.*)|(do smaku.*))\z/,
                      message: 'nieprawidłowe , proszę wpisz ilość w formacie liczbowym' }
  validates :quantity_unit, quantity_unit_in_whitelist: true
  delegate :name, to: :ingredient, allow_nil: true

  before_validation :split_quantity

  def split_quantity # rubocop:disable Metrics/AbcSize,Metrics/MethodLength,Metrics/CyclomaticComplexity
    return if quantity.nil?

    quantity = self.quantity.strip
    quantity_amount = case quantity
                      when %r{\d* i \d*/\d*}
                        whole_num = quantity[%r{\d* i \d*/\d*}].split(' ')[0].to_f
                        numerator = quantity[%r{\d* i \d*/\d*}].split(' ')[2].split('/')[0].to_f
                        denominator = quantity[%r{\d* i \d*/\d*}].split(' ')[2].split('/')[1].to_f

                        whole_num + (numerator / denominator)
                      when %r{\d* \d*/\d*}
                        whole_num = quantity[%r{\d* \d*/\d*}].split(' ')[0].to_f
                        numerator = quantity[%r{\d* \d*/\d*}].split(' ')[1].split('/')[0].to_f
                        denominator = quantity[%r{\d* \d*/\d*}].split(' ')[1].split('/')[1].to_f

                        whole_num + (numerator / denominator)
                      when %r{\d*/\d*}
                        quantity[%r{\d*/\d*}].split('/')[0].to_f / quantity[%r{\d*/\d*}].split('/')[1].to_i
                      when /^\d*[.]\d*/
                        quantity[/^\d*[.]\d*/].to_f
                      when /^\d*,\d*/
                        quantity.split(',')[0].to_i + (quantity.split(',')[1].to_f / 10)
                      else
                        quantity[/^\d*/]
                      end
    self.quantity_amount = quantity_amount.to_f unless quantity_amount == ''
    quantity_unit = quantity[/do smaku/] || quantity[/[[a-z]|ł]+[[a-z]|ł|ą|ę|ż|ź|ś|ć|ń|ó]*\z/]
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
  return 'szt' if unit.nil? || unit == ''

  acceptable_matches.map do |match, abbr|
    return abbr if unit =~ match
  end
end
