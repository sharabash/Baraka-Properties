window.baraka = window.baraka? window.baraka : {};
$(function() {
	var dialog = $('#dialog');
	$.extend(window.baraka, {
		_delete_unit: function(el) {
			var me = $(el);
			dialog.empty();
			dialog.attr('title','Delete Unit');
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
						var ids = me.attr('name').replace(/^delete_building_([\d]+)_unit_([\d]+)$/,'$1,$2');
						var building_id = ids.split(/,/)[0];
						var unit_id = ids.split(/,/)[1];
						var url = '/admin/building/'+ building_id +'/units/'+ unit_id + '/delete';
						$.post(url, 
						function(r,s) {
							alert('Unit deleted.');
							dialog.dialog('destroy');
							location.reload();
						});
					},
					Cancel: function() {
						dialog.dialog('destroy');
					}
				}
			});
		}
	});
});
