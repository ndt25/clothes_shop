$(function () {

	$('.delete').on('click', function () {
		$(this).closest('tr').remove();
	});

});