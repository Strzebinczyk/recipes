# frozen_string_literal: true

module ApplicationHelper
  def turbo_id_for(obj)
    obj.persisted? ? obj.id : obj.hash
  end

  def ingredient_autocomplete
    Ingredient.pluck(:name).map { { label: _1, value: _1 } }.to_json
  end

  def search_autocomplete
    (Tag.pluck(:name).map { { label: _1, value: _1 } } + Ingredient.pluck(:name).map {
      { label: _1, value: _1 }
    }).to_json
  end
end
