class CreateColorProduct < ActiveRecord::Migration
  def change
    create_table :colors_products, {:id => false} do |t|
      t.integer :product_id
      t.integer :color_id
    end
  end
end
