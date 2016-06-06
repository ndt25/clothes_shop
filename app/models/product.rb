class Product < ActiveRecord::Base
	# Validations
	
		validates :name, presence: { message: 'Tên sản phẩm không được bỏ trống' }
		validates :price, presence: { message: 'Giá sản phẩm không được bỏ trống' }
		validates :category_id, presence: { mesage: 'Loại không được bỏ trống' }
		validates :color_id, presence: { message: 'Màu không được bỏ trống' }
		validates :size_id, presence: { message: 'Kích thước không được bỏ trống' }
		validates :description, presence: { message: 'Mô tả không được bỏ trống' }
		validates :upload_files, presence: { message: 'Phải có ít nhất một hình ảnh' }
	
	# / Validations

	# Associations
	
		has_many :order_details
		has_many :upload_files, foreign_key: 'object_id', dependent: :destroy
		belongs_to :category
		belongs_to :color
		belongs_to :size
	
	# / Associations
end