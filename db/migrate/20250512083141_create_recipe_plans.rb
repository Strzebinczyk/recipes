class CreateRecipePlans < ActiveRecord::Migration[8.0]
  def change
    create_table :recipe_plans do |t|
      t.belongs_to :plan, null: false, foreign_key: true
      t.belongs_to :recipe, null: false, foreign_key: true

      t.timestamps
    end
  end
end
