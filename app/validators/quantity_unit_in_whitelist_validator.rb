# frozen_string_literal: true

class QuantityUnitInWhitelistValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors.add(attribute, (:not_on_whitelist || 'Hello')) unless whitelist_conditions? value
  end

  def whitelist_conditions?(quantity_unit)
    ['g', 'ml', 'do smaku', 'łyżcz', 'łyż', 'szt', 'ząb', 'pusz', 'pęcz', 'szkl', 'garść', 'szczypt',
     'kawał', 'opak'].include?(quantity_unit) || quantity_unit.nil?
  end
end
