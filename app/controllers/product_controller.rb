class ProductController < ApplicationController

	layout 'layout'

	def list
		# Lay DL = model
		@products = Product.all

		# Tao HTML / render view
		# render 'list', layout: 'layout'
	end

	def up
		if params[:id].present?
			@product = Product.find(params[:id])
		else
			@product = Product.new
		end

		if request.post?
			# Save
			@product.assign_attributes(
				params[:product].permit(:name, :price, :category_id, :color_id, :size_id, :description, { upload_file_ids: [] })
			)

			if @product.save
				return redirect_to '/product/manage'
			end
		end

		render layout:'back_layout'		
	end

	def detail
		# Lay id ma nguoi dung truyen vao
		id = params[:id]

		# Tim san pham theo id do
		@product = Product.find(id)

	end
	
	def cart	
	end

	def manage
		@products = Product.all

		render layout: 'back_layout'	
	end

	def delete
		Product.delete params[:id]

		return redirect_to '/product/manage'
	end
end