class ApplicationFormBuilder < ActionView::Helpers::FormBuilder

	# params: label
	def field type, method, options = {}, params = {}
		options[:class] = 'form-control' if options[:class].blank?

		input_html = case type
			when 'text'
				text_field(method, options)
			when 'email'
				email_field(method, options)
			when 'password'
				password_field(method, options)
			when 'date'
				date_field(method, options)
			when 'textarea'
				text_area(method, options)
			when 'number'
				number_field(method, options)
			when 'select'
				select(method, params[:select_options_list] || [], params[:select_options] || {}, options)
			when 'file'
				if params[:input_quantity].blank? || params[:input_quantity] == 1
					options[:multiple] = false

					if params[:files].present?
						'<div><article class="form-upload-control has-file">' +
							'<div class="preview-image">' +
								'<a class="remove">×</a>' +
								'<label>' +
									'<img src="' + "/assets/#{params[:files][0].id}_#{params[:files][0].name}" + '" />' +
									'<input type="file" />' +
								'</label>' +
								'<div class="progress progress-sm"><div class="progress-bar progress-bar-aqua-active" role="progressbar" style="width: 0%;"></div></div>' +
								hidden_field(method, options.merge({ value: params[:files][0].id })) +
							'</div>' +
						'</article></div>'
					else
						'<div><article class="form-upload-control">' +
							'<div class="preview-image">' +
								'<a class="remove">×</a>' +
								'<label>' +
									'<img src="/assets/shared/upload_icon_128.png" />' +
									'<input type="file" />' +
								'</label>' +
								'<div class="progress progress-sm"><div class="progress-bar progress-bar-aqua-active" role="progressbar" style="width: 0%;"></div></div>' +
								hidden_field(method, options) +
							'</div>' +
						'</article></div>'
					end
				else
					options[:multiple] = true

					input_html_temp = '<div>'
					(0...params[:files].count).each do |i|
						input_html_temp +=
							'<article class="form-upload-control has-file">' +
								'<div class="preview-image">' +
									'<a class="remove">×</a>' +
									'<label>' +
										'<img src="' + "/assets/#{params[:files][i].id}_#{params[:files][i].name}" + '" />' +
										'<input type="file" />' +
									'</label>' +
									'<div class="progress progress-sm"><div class="progress-bar progress-bar-aqua-active" role="progressbar" style="width: 0%;"></div></div>' +
									hidden_field(method, options.merge({ value: params[:files][i].id })) +
								'</div>' +
							'</article>'
					end

					(params[:files].count...params[:input_quantity]).each do
						input_html_temp +=
							'<article class="form-upload-control">' +
								'<div class="preview-image">' +
									'<a class="remove">×</a>' +
									'<label>' +
										'<img src="/assets/shared/upload_icon_128.png" />' +
										'<input type="file" />' +
									'</label>' +
									'<div class="progress progress-sm"><div class="progress-bar progress-bar-aqua-active" role="progressbar" style="width: 0%;"></div></div>' +
									hidden_field(method, options) +
								'</div>' +
							'</article>'
					end
					input_html_temp + '</div>'
				end
			else
				''
			end

		('<div class="form-group">' +
			label(method, params[:label]) +
			input_html +
		'</div>').html_safe
	end
end