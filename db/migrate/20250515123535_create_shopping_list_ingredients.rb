# frozen_string_literal: true

class CreateShoppingListIngredients < ActiveRecord::Migration[8.0]
  def change
    create_table :shopping_list_ingredients do |t|
      t.belongs_to :ingredient, null: false, foreign_key: true
      t.belongs_to :shopping_list, null: false, foreign_key: true
      t.float :quantity_amount
      t.string :quantity_unit

      t.timestamps
    end
  end
end
