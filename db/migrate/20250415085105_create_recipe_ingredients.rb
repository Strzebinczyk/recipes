# frozen_string_literal: true

class CreateRecipeIngredients < ActiveRecord::Migration[8.0]
  def change
    create_table :recipe_ingredients do |t|
      t.belongs_to :ingredient, null: false, foreign_key: true
      t.belongs_to :recipe, null: false, foreign_key: true
      t.string :quantity
      t.float :quantity_amount
      t.string :quantity_unit

      t.timestamps
    end
  end
end
