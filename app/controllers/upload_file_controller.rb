class UploadFileController < ApplicationController

	skip_before_filter :verify_authenticity_token

	def upload
		# Luu du lieu len server (co id, name)
		file = UploadFile.create name: params[:file].original_filename.gsub('-', '_').gsub(' ', '_')

		# Luu du lieu hinh anh o thu muc
		File.open('app/assets/file_uploads/' + file.id.to_s + '_' + file.name, 'wb') do |f|
			f.write params[:file].read
		end

		render json: {
			status: 0,
			result: {
				id: file.id,
				path: '/assets/' + file.id.to_s + '_' + file.name
			}
		}
	end

end