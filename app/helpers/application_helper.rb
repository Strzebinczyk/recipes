# frozen_string_literal: true

module ApplicationHelper
  def turbo_id_for(obj)
    obj.persisted? ? obj.id : obj.hash
  end

  def ingredient_autocomplete
    Ingredient.pluck(:name).map { { label: _1, value: _1 } }.to_json
  end

  def search_autocomplete
    names = Tag.pluck(:name) + Ingredient.pluck(:name)
    hash = names.map { |name| { label: name, value: name } }
    hash.to_json
  end
end
