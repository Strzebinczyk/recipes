# frozen_string_literal: true

class CreateIngredients < ActiveRecord::Migration[8.0]
  def change
    create_table :ingredients do |t|
      t.string :name
      t.string :quantity

      t.timestamps
    end
  end
end
