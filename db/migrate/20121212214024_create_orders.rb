class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :order_number
      t.integer :customer_number
      t.datetime :ordered_at
      t.string :product_model
      t.string :product_name
      t.money :sell_price
      t.money :earnings

      t.timestamps
    end
    add_index :orders, [:order_number, :product_model], unique: true
    add_index :orders, :product_model
    add_index :orders, :product_name
    add_index :orders, :customer_number
    add_index :orders, :ordered_at
  end
end
