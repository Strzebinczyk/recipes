class CreateIngredients < ActiveRecord::Migration[8.0]
  def change
    create_table :ingredients do |t|
      t.belongs_to :recipe, index: true, foreign_key: true
      t.string :name
      t.string :quantity

      t.timestamps
    end
  end
end
