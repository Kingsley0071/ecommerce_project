class CreateOrderItems < ActiveRecord::Migration[8.0]
  def change
    create_table :order_items do |t|
      t.references :order, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.integer :quantity, null: false
      t.decimal :price, precision: 10, scale: 2, null: false  # Store price at time of order
      t.decimal :tax_rate, precision: 5, scale: 2, null: false, default: 0.0 # Store tax rate at time of order
      t.timestamps
    end
  end
end
