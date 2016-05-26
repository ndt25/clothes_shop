$(function () {

	// Init

		// Form
		
			$('.init-form').each(function () {
				_initForm($(this));
			});
		
		// / Form
	
	// / Init

});

// Form
	
	/*
		Params
			params:
				remote: boolean
					Whether preventDefault or not
				submit: function
	*/
	function _initForm($form, params) {
		params = params || {};

		var defaultIcon = '/assets/shared/upload_icon_128.png';

		// Single file upload
		
			$form.find('.form-upload-control').each(function () {
				var
					$wrapper = $(this),
					$fileUpload = $wrapper.find('input[type="file"]'),
					$hiddenInput = $wrapper.find('input[type="hidden"]'),
					$pathInput = $wrapper.find('input[data-object="file_path"]'),
					$progress = $wrapper.find('.progress-bar'),
					$previewImage = $wrapper.find('img'),
					ratio = $wrapper.data('ratio'),
					dimension = $wrapper.data('dimension'),
					minDimension = $wrapper.data('min_dimension'),
					maxDimension = $wrapper.data('max_dimension');

				// On change
					
					$fileUpload.on('change', function () {

						var input = this;

						// Preview
							
							// Khai báo đối tượng
							var reader = new FileReader();

							// Khai báo sự kiện
							reader.onload = function (e) {
								// Validate
								if (!ratio && !dimension && !minDimension && !maxDimension) {
									$previewImage.attr('src', e.target.result);
								}
								else {
									$('<img style="position:absolute; left: -9999px;" />').on('load', function () {
										if (ratio) {
											if (this.width / this.height != eval(ratio)) {
												_popupPrompt({
													title: 'Error',
													content: 'Image ratio must be ' + ratio
												});
												return;
											}
										}
										if (dimension) {
											var d = dimension.split('x');
											if (this.width != d[0] || this.height != d[1]) {
												_popupPrompt({
													title: 'Error',
													content: 'Image size must be ' + dimension + 'px'
												});
												return;
											}
										}
										if (minDimension) {
											var d = minDimension.split('x');
											if (this.width < d[0] || this.height < d[1]) {
												_popupPrompt({
													title: 'Error',
													content: 'Image size must be minimum ' + minDimension + 'px'
												});
												return;
											}
										}
										if (maxDimension) {
											var d = maxDimension.split('x');
											if (this.width > d[0] || this.height > d[1]) {
												_popupPrompt({
													title: 'Error',
													content: 'Image size must be maximum ' + maxDimension + 'px'
												});
												return;
											}
										}

										$previewImage.attr('src', this.src);
										this.remove();

										upload();
									}).attr('src', e.target.result).appendTo('body');
								}
							}

							// Thực hiện xử lý -> Xong sẽ gọi sự kiện
							reader.readAsDataURL(input.files[0]);
						
						// / Preview

						// Upload
							
							if (!ratio && !dimension && !minDimension && !maxDimension) {
								upload();
							}

							function upload() {
								$progress.css('width', '0%');
								$wrapper.addClass('processing');

								// Tao data de gui len server
								formData = new FormData();
								formData.append('file', input.files[0]);

								// Request len server (url, method, data)
								$.ajax({
									url: '/upload_file/upload',
									method: 'POST',
									data: formData,
									contentType: false,
									processData: false,
									cache: false,
									dataType: 'JSON',
									xhr: function () {
										var xhr = $.ajaxSettings.xhr();
										if(xhr.upload){
											xhr.upload.addEventListener('progress', function(e) {
												if(e.lengthComputable){
													$progress.css('width', (e.loaded/e.total * 100) + '%');
												}
											}, false);
										}
										return xhr;
									}
								})
								// Server se xu ly va tra ve JSON (co the thanh cong hoac that bai)
								.always(function () {
									$wrapper.removeClass('processing');
								}).done(function (data) {
									if (data.status == 0) {
										$hiddenInput.val(data.result.id);
										$pathInput.val(data.result.path);
										$wrapper.addClass('has-file');
									}
									else {
										$previewImage.attr('src', defaultIcon);
										$hiddenInput.val('');
										$pathInput.val('');
										$wrapper.removeClass('has-file');
										alert('Lỗi');
									}
								}).fail(function () {
									$previewImage.attr('src', defaultIcon);
									$hiddenInput.val('');
									$pathInput.val('');
									$wrapper.removeClass('has-file');
									alert('Lỗi');
								});
							}
						
						// / Upload
					});
				
				// / On change

				// Remove
				
					$wrapper.find('.remove').on('click', function () {
						$previewImage.attr('src', defaultIcon);
						$hiddenInput.val('');
						$pathInput.val('');
						$wrapper.removeClass('has-file');
					});
				
				// / Remove
			});

		// / Single file upload

		// HABTM select
			
			(function () {
				var ajax;

				$form.find('[data-input-type="habtm_select"]').val('').each(function () {
					var
						$input = $(this),
						$itemsList = $input.closest('.autocomplete-input-ctn').find('.list'),
						$inputsList = $input.closest('.form-group').find('.tags-ctn'),
						lastVal = this.value,
						timeout;

					$itemsList.html('<a class="item">Put your keyword</a>');
					initInputs($inputsList.find('.item'));

					$input.on({
						'click': function (e) {
							e.stopPropagation();
						},
						'focus': function () {
							focus();
						},
						'keydown': function (e) {
							switch (e.which || e.keyCode) {
								// Up
								case 38:
									e.preventDefault();
									var $current = $itemsList.find('a.hover');
									$current.removeClass('hover');
									if ($current.is(':first-child')) {
										$itemsList.find('> :last-child').addClass('hover');
									}
									else {
										$current.prev().addClass('hover');
									}
									break;

								// Down
								case 40:
									e.preventDefault();
									var $current = $itemsList.find('a.hover');
									$current.removeClass('hover');
									if ($current.is(':last-child')) {
										$itemsList.find('> :first-child').addClass('hover');
									}
									else {
										$current.next().addClass('hover');
									}
									break;

								// Enter
								case 13:
									e.preventDefault();
									$itemsList.find('a.hover').click();
									break;

								//Tab
								case 9:
									focusout();
									break;

								default:
									break;
							}
						},
						'keyup': function () {
							if (this.value == lastVal) {
								return;
							}
							lastVal = this.value;

							if (ajax) {
								ajax.abort();
							}

							if (!this.value) {
								$itemsList.html('<a class="item">Put your keyword</a>');
								return;
							}

							var except = $inputsList.find('[type="hidden"]').get().map(function (input) {
									return input.value;
								}).join(',');

							clearTimeout(timeout);
							timeout = setTimeout(function () {
								$.ajax({
									url: $input.data('url'),
									data: {
										keyword: lastVal,
										except: except
									},
									dataType: 'JSON'
								}).done(function (data) {
									if (data.status == 0) {
										var html = '';
										$.each(data.result, function (id, text) {
											html += '<a class="item" data-value="' + id + '">' + text + '</a>'
										});

										$itemsList.html(html);

										$itemsList.find('a:eq(0)').addClass('hover');
										initItems($itemsList.find('a'));
									}
									else if (data.status == 1) {
										$itemsList.html('<a class="item">Not match with this keyword</a>');
									}
									else {
										alert('Lỗi');
										$itemsList.html('<a class="item">Put your keyword</a>');
									}
								}).fail(function (xhr, status) {
									if (status != 'abort') {
										alert('Lỗi');
									}
									$itemsList.html('<a class="item">Put your keyword</a>');
								});
							}, 250);
						}
					});

					function focus() {
						$input.addClass('focus');
						$(document).on('click', function (e) {
							focusout();
						});
					}

					function focusout() {
						$input.removeClass('focus');
					}

					function initItems($items) {
						$items.on({
							'click': function (e) {
								e.stopPropagation();

								var $item = $(this);

								var $inputItem = $(
									'<article class="item">' +
										'<input type="hidden" value="' + $item.data('value') + '" name="' + $input.attr('name') + '[]" />' +
										'<span class="text">' + $item.text() + '</span>' +
										'<a class="remove">&times;</a>' +
									'</article>'
								);
								initInputs($inputItem);

								$inputsList.append($inputItem);

								$input.focus().val('');
								$itemsList.html('');
							},
							'mouseenter': function () {
								$(this).addClass('hover').siblings('.hover').removeClass('hover');
							}
						});
					}

					function initInputs($items) {
						$items.each(function () {
							var $item = $(this);
							$item.find('.remove').on('click', function () {
								$item.remove();
							});
						});
					}
				});
			})();
		
		// / HABTM select

		$form.on('submit', function (e) {
			if ($form.find('.processing').length > 0) {
				_popupPrompt({
					title: 'Uploading',
					content: 'Please wait until upload completed'
				});

				e.preventDefault();
				return;
			}

			$form.find('[data-input-type="habtm_select"]').attr('name', '');

			if ('remote' in params && params['remote']) {
				e.preventDefault();
			}
			if ('submit' in params) {
				params['submit']();
			}
		});

	}

// / Form