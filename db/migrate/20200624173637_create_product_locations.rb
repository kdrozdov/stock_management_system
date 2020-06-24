class CreateProductLocations < ActiveRecord::Migration[6.0]
  def change
    create_table :product_locations do |t|
      t.references :product, null: false, foreign_key: true
      t.references :stock, null: false, foreign_key: true
      t.integer :quantity, null: false, default: 0

      t.timestamps
    end
    add_index :product_locations, [:product_id, :stock_id], unique: true
  end
end
