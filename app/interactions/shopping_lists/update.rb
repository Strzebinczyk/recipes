# frozen_string_literal: true

module ShoppingLists
  class Update < ActiveInteraction::Base
    object :shopping_list
    hash :params, strip: false

    def execute # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
      new_shopping_list_ingredients_attributes =
        (params['shopping_list_ingredients_attributes'] || {})
        .reject { _1['name'] == '' || _1['quantity_amount'] == '' }
        .transform_values do |shopping_list_ingredient|
          name = shopping_list_ingredient.delete('name')
          ingredient = Ingredient.find_by(name:) || Ingredient.create(name:)

          { **shopping_list_ingredient, 'ingredient_id' => ingredient.id }
        end

      new_params = { **params, 'shopping_list_ingredients_attributes' => new_shopping_list_ingredients_attributes }
      errors.merge!(shopping_list.errors) unless shopping_list.update(new_params)

      shopping_list
    end
  end
end
