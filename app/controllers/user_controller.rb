class UserController < ApplicationController
	layout 'back_layout'

	def register
		@_title = '123'
		# Co the nhan dc 1 params id
		if params[:id].present?
			@user = User.find(params[:id])
		else
			@user = User.new
		end

		if request.post?
			# Save
			if params[:user][:password].present?
				require 'digest/md5'
				params[:user][:password] = Digest::MD5.hexdigest params[:user][:password]
			end

			@user.assign_attributes(
				params[:user].permit(:email, :password, :name, :birthday, :address, :number_phone)
			)

			@user.save
		end

		@users = User.all

		render layout: 'empty'
	end



	def login

		if request.post?
			# Khi vo day moi co params[:user] - tuc la bam nut dang nhap
			# Minh se kiem tra thong tin -> dang nhap

			email = params[:user][:email]
			require 'digest/md5'
			password = Digest::MD5.hexdigest params[:user][:password]

			user = User.where(email: email, password: password).first

			if user.present?
				# Thong tin dung
				session[:user_id] = user.id
			else
				# Thong tin sai
				flash[:error] = 'Email hoặc mật khẩu không chính xác'
			end
		end

		render layout: 'empty'

	end
end