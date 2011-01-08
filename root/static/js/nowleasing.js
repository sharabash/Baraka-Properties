function reset_filters() {
	var _form = $('#filters');
	_form.find('input, select').each(function() {
		var el = $(this);
		if (el.is('input[type=radio]') || el.is('input[type=checkbox]'))
			el.attr('checked','');
		else
		if (el.is('select'))
			el.get(0).selectedIndex = 0;
		else
		if (el.is('input[type=text]') || el.is('input[type=hidden]'))
			el.attr('value','');
	});
	_form.get(0).submit();
};

$(function() {
	$('tbody.building').each(function() {
			var el = $(this);
			if (!el.find('tr.unit').length)
					el.hide();
	});
});

$(function() {
	var inputs = $('#filters input.rent');
	var min = inputs.filter('.min');
	var max = inputs.filter('.max');
	inputs.change(function(ev) {
		var val = $(this).val().replace(/[^\d]/g,'');
		$(this).val(val);
		if (val && $(this).hasClass('min') && (!max.val() || (max.val() && parseInt(val) >= parseInt(max.val())))) {
			var other_val = parseInt(val) + 100;
			other_val = (other_val <= 9999)? other_val : 9999;
			max.val(other_val);
		} else
		if (val && $(this).hasClass('max') && (!min.val() || (min.val() && parseInt(val) <= parseInt(min.val())))) {
			var other_val = parseInt(val) - 100;
			other_val = (other_val >= 0)? other_val : 0;
			min.val(other_val);
		} else
		if (!val) {
			min.val('');
			max.val('');
		}
	});
});

$(function() {
	$('#more-options-trigger').mousedown(function(ev) {
		if ($(this).hasClass('collapsed')) {
			$(this).removeClass('collapsed').addClass('expanded');
			$('#more-options-section').show();
			$('#more-options-hidden').val('expanded');
		}
		else {
			$(this).removeClass('expanded').addClass('collapsed');
			$('#more-options-section').hide();
			$('#more-options-hidden').val('collapsed');
		}
		ev.stopPropagation? ev.stopPropagation() : ev.cancelBubble = true;
		return false;
	});
});

$(function() {
	var pictures = $("a[rel^='pphoto']");
	pictures.each(function() {
		$(this).attr('href', $(this).attr('href').replace(/width=[0-9]+/, 'width='+ Math.floor($(window).width() * (((Math.sqrt(5) + 1) / 2) - 1))));
		$(this).attr('href', $(this).attr('href').replace(/height=[0-9]+/, 'height='+ Math.floor($(window).height() * (((Math.sqrt(5) + 1) / 2) - 1))));
	});
	pictures.pphoto({ theme: 'facebook' });
});

baraka._dialog = function(options) {
	if (!baraka.__dialog)
		baraka.__dialog = $('<div></div>')
			.html(options.content || '')
			.dialog({
				autoOpen: false,
				title: options.title || '',
				closeOnEscape: true,
				dialogClass: 'dialog',
				width: 618,
				zIndex: 3,
				draggable: false,
				resizable: false,
				modal: true
			});
	else {
		if (options.content)
			baraka.__dialog.html(options.content);
		if (options.title)
			baraka.__dialog.dialog('option', 'title', options.title);
	}
	baraka.__dialog.dialog('open');
};
