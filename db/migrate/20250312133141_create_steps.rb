# frozen_string_literal: true

class CreateSteps < ActiveRecord::Migration[8.0]
  def change
    create_table :steps do |t|
      t.belongs_to :recipe, index: true, foreign_key: true
      t.text :instructions

      t.timestamps
    end
  end
end
