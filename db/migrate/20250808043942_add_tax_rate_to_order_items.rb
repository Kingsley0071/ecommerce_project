class AddPriceAndTaxRateToOrderItems < ActiveRecord::Migration[8.0]
  def change
    add_column :order_items, :price, :decimal, precision: 10, scale: 2
    add_column :order_items, :tax_rate, :decimal, precision: 5, scale: 4
  end
end
