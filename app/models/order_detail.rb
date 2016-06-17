class OrderDetail < ActiveRecord::Base
	self.primary_key = :product_id, :order_id

	belongs_to :order
	belongs_to :product
end
