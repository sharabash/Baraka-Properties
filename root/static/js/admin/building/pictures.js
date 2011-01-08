$(function() {
	var dialog = $('#dialog');
	var pictures = $("a[rel^='pphoto']");
	pictures.each(function() {
		$(this).attr('href', $(this).attr('href').replace(/width=[0-9]+/, 'width='+ Math.floor($(window).width() * (((Math.sqrt(5) + 1) / 2) - 1))));
		$(this).attr('href', $(this).attr('href').replace(/height=[0-9]+/, 'height='+ Math.floor($(window).height() * (((Math.sqrt(5) + 1) / 2) - 1))));
	});
	pictures.pphoto({ theme: 'facebook' });
	$("a.delete.picture").mousedown(function(e) {
		var me = $(this);
		dialog.empty();
		dialog.attr('title','Delete Picture');
		dialog.html("<p>Really delete?</p>");
		dialog.removeClass('hidden');
		dialog.dialog({
			bgiframe: true,
			resizable: false,
			height: 140,
			modal: true,
			overlay: {
				backgroundColor: '#000',
				opacity: 0.5
			},
			buttons: {
				Delete: function() {
					var url = me.attr('name').replace(/_/g,'/');
					$.post(url, function(r,s) {
						alert('Picture deleted.');
						location.reload();
					});
					$(this).dialog('destroy');
				},
				Cancel: function() {
					$(this).dialog('destroy');
				}
			}
		});
	});
});
