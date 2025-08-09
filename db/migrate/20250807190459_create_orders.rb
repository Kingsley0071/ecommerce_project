class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.decimal :total
      t.string :address
      t.string :city
      t.string :province
      t.string :postal_code
      t.string :status

      t.timestamps
    end
  end
end
