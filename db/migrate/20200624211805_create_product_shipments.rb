class CreateProductShipments < ActiveRecord::Migration[6.0]
  def change
    create_table :product_shipments do |t|
      t.integer :quantity, null: false, default: 0
      t.decimal :amount, null: false, default: 0
      t.references :stock, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true

      t.timestamps
    end
  end
end
