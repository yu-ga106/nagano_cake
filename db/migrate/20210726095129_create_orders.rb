class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.integer :customer_id
      t.string :address
      t.integer :total_payment
      t.integer :payment_method, default: 0
      t.string :name
      t.string :postal_code
      t.integer :shipping_cost
      t.integer :status, default: 0

      t.timestamps
    end
  end
end