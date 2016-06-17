class ProductController < ApplicationController

	skip_before_filter :verify_authenticity_token, only: :add_to_cart

	layout 'layout'

	def list
		page = params[:page] || 1
		per = 2

		# Lay DL = model
		@products = Product.paginate(page: page, per_page: per)

		# Tao HTML / render view
		# render 'list', layout: 'layout'*
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

	def add_to_cart
		id 			= params[:id]
		quantity 	= params[:quantity]

		# Kiem tra xem da co gio hang hay chua
		# Neu chua thi khoi tao
		session[:cart] ||= {} # Neu cart da ton tai thi giu nguyen, neu chua thi = {}

		# Them san pham vao gio hang
		session[:cart][id] = quantity

		# Chuyen huong sang trang /product/list
		redirect_to '/product/list'
	end
	
	def cart
		if session[:cart].blank? # blank? kt co rỗng hay ko ,present? kt co tồn tại chưa
			return redirect_to '/product/list'
		end

		ids = session[:cart].keys 
		@products = Product.find(ids)
	end

	def update_cart
		#khoi tao gio hang moi
		cart = {}

		if params[:cart].present?
			params[:cart].each do |item|	#params luu du lieu gui tu form ngdung len server
				cart[item[:id]] = item[:quantity] #lay id voi qantity moi, [:cart][:id] name
			end
		end

		session[:cart] = cart

		redirect_to '/product/cart' #chuyen huong sang cart
	end

	def manage
		@products = Product.all

		render layout: 'back_layout'	
	end

	def delete
		Product.delete params[:id]

		return redirect_to '/product/manage'
	end

	def checkout
		if session[:cart].blank?
			redirect_to '/product/list'
		end

		ids = session[:cart].keys
		@products = Product.find(ids)
	end

	def order
		# Lay cac san pham dang dat hang
		cart = session[:cart]

		# Tao hoa don
		order = Order.new

		# Gan gia tri cho hoa don
		order.user_id = 1  # Gan tam ,id ng dung dang dang nhap
		order.total = 0
		order.total = 0

		cart.each do |id, quantity|
			# Lay product
			product = Product.find(id)

			# Tao chi tiet hoa don
			order_detail = OrderDetail.new

			# Gan gia tri cho chi tiet hoa don
			order_detail.product_id = id
			order_detail.quantity = quantity
			order_detail.price = product.price
			order_detail.total = product.price * quantity.to_i

			order.total = order.total + order_detail.total

			# Them chi tiet hoa don vao gio hang
			order.order_details << order_detail
		end

		order.save

		session[:cart] = {}
	end
end