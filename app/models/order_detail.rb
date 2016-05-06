class OrderDetail < ActiveRecord::Base
	self.primary_keys = :product_id, :size_id, :color_id, :order_id

	belongs_to :order
	belongs_to :product
end
