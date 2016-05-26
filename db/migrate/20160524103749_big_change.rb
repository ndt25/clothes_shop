class BigChange < ActiveRecord::Migration
  def change
  	drop_table :colors_products
  	drop_table :products_sizes

  	remove_column :order_details, :size_id
  	remove_column :order_details, :color_id

  	add_column :products, :size_id, :integer
  	add_column :products, :color_id, :integer
  end
end
