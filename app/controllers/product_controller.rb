class ProductController < ApplicationController
	
	def list
		render layout:'layout'
	end
	def up	
		render layout:'back_layout'		
	end
	def detail
		render layout:'layout'
	end
	def cart	
		render layout:'layout'	
	end
	def manage
		render layout:'back_layout'	
	end
end


