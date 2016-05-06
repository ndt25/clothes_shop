class Product < ActiveRecord::Base
	has_many :order_details
	belongs_to :category
	has_and_belongs_to_many :colors
	has_and_belongs_to_many :sizes
end
