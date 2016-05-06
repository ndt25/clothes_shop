class Category < ActiveRecord::Base
	has_many :products
	has_many :category_childs,
		class_name: 'Category',
		foreign_key: 'category_parent_id'
	belongs_to :category_parent,
		class_name: 'Category',
		foreign_key: 'category_parent_id'
end
