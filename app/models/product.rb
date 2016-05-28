class Product < ActiveRecord::Base
	# Validations
	
		validates :name, presence: true, message: 'Tên sản phẩm không được bỏ trống'
	
	# / Validations

	# Associations
	
		has_many :order_details
		has_many :upload_files, foreign_key: 'object_id', dependent: :destroy
		belongs_to :category
		belongs_to :color
		belongs_to :size
	
	# / Associations
end