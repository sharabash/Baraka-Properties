$(function() {
	var dialog = $('#dialog');
	$("a.delete.building").mousedown(function(e) {
		var me = $(this);
		dialog.empty();
		dialog.attr('title','Delete Building');
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
					var id = me.attr('name').replace(/delete_/,'');
					$.post('/admin/building/'+ id + '/delete', 
					function(r,s) {
						alert('Building deleted.');
						location.href = '/admin';
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
