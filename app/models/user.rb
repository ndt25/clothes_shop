class User < ActiveRecord::Base

	# Validations

		validates :email,
			presence: { message: 'Email không được bỏ trống' }, 
			uniqueness: { message: 'Email đã được sử dụng' }

		validates :password,
			presence: { message: 'Mật khẩu không được bỏ trống' }, 
			confirmation: { message: 'Mật khẩu không trùng khớp' }

		validates :name, presence:{ message: 'Họ và tên không được bỏ trống' }
 
		validates :address, presence: { message: 'Địa chỉ không được bỏ trống' }

		validates :number_phone, presence: { message: 'Số điện thoại không được bỏ trống'}







	# / Validations


	has_many :orders
end
