class CreateShoppingLists < ActiveRecord::Migration[8.0]
  def change
    create_table :shopping_lists do |t|
      t.belongs_to :plan, index: true, foreign_key: true

      t.timestamps
    end
  end
end
