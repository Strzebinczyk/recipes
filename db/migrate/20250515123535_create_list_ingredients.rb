class CreateListIngredients < ActiveRecord::Migration[8.0]
  def change
    create_table :list_ingredients do |t|
      t.belongs_to :ingredient, null: false, foreign_key: true
      t.belongs_to :list, null: false, foreign_key: true
      t.string :quantity

      t.timestamps
    end
  end
end
