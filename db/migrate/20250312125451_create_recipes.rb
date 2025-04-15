# frozen_string_literal: true

class CreateRecipes < ActiveRecord::Migration[8.0]
  def change
    create_table :recipes do |t|
      t.belongs_to :user, index: true, foreign_key: true
      t.string :name
      t.integer :serving

      t.timestamps
    end
  end
end
