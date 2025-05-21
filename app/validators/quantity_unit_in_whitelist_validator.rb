# frozen_string_literal: true

class QuantityUnitInWhitelistValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors.add(attribute, :not_on_whitelist) unless whitelist_conditions?(value)
  end

  private

  def whitelist_conditions?(quantity_unit) # rubocop:disable Metrics/AbcSize,Metrics/CyclomaticComplexity,Metrics/PerceivedComplexity
    quantity_unit =~ /łyż.*/ || quantity_unit =~ /szt.*/ || quantity_unit =~ /ząb.*/ || quantity_unit =~ /pusz.*/ ||
      quantity_unit =~ /kawał.*/ || quantity_unit =~ /pęcz.*/ || quantity_unit =~ /szkl.*/ ||
      quantity_unit =~ /garś.*/ || quantity_unit =~ /szcz.*/ || quantity_unit == 'g' || quantity_unit == 'ml' ||
      quantity_unit == 'do smaku' || quantity_unit.nil?
  end
end
