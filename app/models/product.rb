class Product < ActiveRecord::Base
	has_many :order_details
	has_many :upload_files, foreign_key: 'object_id'
	belongs_to :category
	belongs_to :color
	belongs_to :size
end