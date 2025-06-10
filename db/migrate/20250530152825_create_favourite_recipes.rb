# frozen_string_literal: true

class CreateFavouriteRecipes < ActiveRecord::Migration[8.0]
  def change
    create_table :favourite_recipes do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :recipe, null: false, foreign_key: true

      t.timestamps
    end
  end
end
