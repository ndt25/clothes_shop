class CreateOrderDetails < ActiveRecord::Migration
  def change
    create_table :order_details, {:id => false} do |t|
      t.integer :product_id
      t.integer :size_id
      t.integer :color_id
      t.integer :order_id
      t.integer  :price
      t.integer :quantity
      t.integer  :total

      t.timestamps null: false
    end
  end
end
