var Baraka = function() { // singleton
	// init constructor
	var b = this;
	$.each(this, function(key,val) {
		if (val._prototype || val._constructor) {
			val._prototype = val._prototype || {};
			val._constructor = val._constructor || function(){};
			val._constructor.prototype = val._prototype;
			val._prototype._ = b;
			if (val._hybrid) {
				b[key] = val._constructor;
				$.extend(b[key], val._prototype);
			} else {
				val._constructor.prototype._ = b;
				b[key] = new val._constructor;
			}
		}
	});
	b.init();
};
Baraka.prototype = {
	buildings: {},
	events: {},
	on: function(ev,fn) {
		if (!this.events[ev]) { this.events[ev] = []; }
		this.events[ev].push(fn);
	},
	exec: function(ev, data) {
		var self = this;
		if (this.events[ev]) {
			$.each(this.events[ev], function(i, fn) {
				fn.call(self, data);
			});
		}
	},
	dom: {
		_constructor: function() {
			var self = this;
			self.iframe = $('#iframe');
			self.div.header = $('#header');
			self.div.footer = $('#footer');
			self.div.content = $('#content');
			self.div.buildings = $('#buildings');
			self.div.modal = $('#modal');
			self.div.modal_mask = $('#modal-mask');
			self.a.admin_login = $('#admin-login');
			self.div.contact_us_modal = $('#contact-us-modal');
			self.a.contact_us_link = $('#contact-us-link');
			self.a.close_contact_us_modal = $('#close-contact-us-modal');
			self.div.building_carousels = $('div.building.carousel');
			self.a.trigger_more = $('a.trigger.more');
			self.a.admin_ctrl_add_building_picture = $('.admin-ctrl-add-building-picture');
			self.a.admin_ctrl_delete_building_picture = $('.admin-ctrl-delete-building-picture');
			self.a.admin_ctrl_add_unit_picture = $('.admin-ctrl-add-unit-picture');
			self.a.admin_ctrl_delete_unit_picture = $('.admin-ctrl-delete-unit-picture');
			self.table.inner = $('table.inner');
			var tbody_tr = self.table.inner.find('> tbody > tr');
			var length = tbody_tr.eq(0).find('> td').length;
			self.table.inner.$_columns = {};
			for (var i = 1; i <= length; i++) {
				self.table.inner.$_columns[i] = tbody_tr.find('> td:nth-child('+ i +')').data('n',i);
			}
			self.table.outer = $('table.outer');
			self.table.outer.$_th_first_child = self.table.outer.find('> thead > tr > th:first-child');
		},
		_prototype: {
			a: {},
			div: {},
			table: {
				buildings: {}
			},
			special: {
				building: { carousels: {} },
				unit: { carousels: {} }
			}
		}
	},
	template: {
		_prototype: {
			make: function(str, data) { // resig's micro templating engine
				var self = this;
				var fn = !/\W/.test(str) ? self.cache[str] = self.cache[str] || self.make(document.getElementById(str).innerHTML) : new Function(
					"obj",
					"var p=[],print=function(){p.push.apply(p,arguments);};" +
						"with(obj){p.push('" +
						str.replace(/[\r\t\n]/g, " ")
							.split("<%").join("\t")
							.replace(/((^|%>)[^\t]*)'/g, "$1\r")
							.replace(/\t=(.*?)%>/g, "',$1,'")
							.split("\t").join("');")
							.split("%>").join("p.push('")
							.split("\r").join("\\'") +
						"');} return p.join('');"
				);
				return data ? fn( data ) : fn;
			},
			cache: {}
		}
	},
	init: {
		_hybrid: true,
		_constructor: function() {
			var self = this;
			$('.building.carousel.active').jMyCarousel({ visible: '2', speed: 150, eltByElt: false, evtStart: 'mouseover', evtStop: 'mouseout' });
			
			$('#picture-modal .inside').draggable({ });
			$('#map-modal .inside').draggable({ handle: '.control', containment: 'parent' });
			self.init.static_binds();
			self.init.live_binds();
		},
		_prototype: {
			static_binds: function() { // static binds: event handling for persistent elements
				var self = this;
				self._.dom.a.admin_login.bind('mousedown', ajax_login);
				self._.dom.a.contact_us_link.bind('mousedown', show_contact_us_modal);
				self._.dom.a.close_contact_us_modal.bind('mousedown', hide_contact_us_modal);
				self._.dom.iframe.bind('load', ajax_upload_callback);
				//table_width() && $(window).bind('resize', table_width);
				//content_height() && $(window).bind('resize', content_height);
				self._.on('ajax-upload-callback', handle_uploaded_picture);
				return;
				function hide_contact_us_modal() {
					self._.dom.div.modal.addClass('hidden');
					self._.dom.div.modal_mask.addClass('hidden');
					self._.dom.div.contact_us_modal.addClass('hidden');
				};
				function show_contact_us_modal() {
					self._.dom.div.modal.removeClass('hidden');
					self._.dom.div.modal_mask.removeClass('hidden');
					self._.dom.div.contact_us_modal.removeClass('hidden');
				};
				function ajax_login() {
					$.ajax({
						async: false,
						success: function(r,s) {
							edit_mode();
							$('ul#buildings').sortable({
								stop: function(e,ui) {
									var to_json = [];
									$(this).find('>li').each(function(i,li) {
										to_json.push({ position: i+1, building_id: $(li).data('id') });
									});
									to_json = $.toJSON(to_json);
									$.post('_/save.cgi', {
										building_positions: to_json
									}, function(r,s) {
									});
								}
							})
						},
						error: function(r,s) {
						},
						complete: function(r,s) {
						},
						timeout: 60,
						type: 'POST',
						url: '_/login.cgi'
					});
				};
				function ajax_upload_callback(){ 
					var doc = $($('#iframe').get(0).contentWindow.document);
					var response = doc.text();
					self._.exec('ajax-upload-callback', response);
				};
				function handle_uploaded_picture(data) {
					data = $.evalJSON(data);
					alert('please note you will not see your pictures until you reload. i will take away this message in due time when you get the point.');
				};
				function edit_mode() {
				self._.admin_mode = true;
					$('.admin').each(function() {
						$(this).removeClass('hidden');
					});
					var config1 = { type: 'text', placeholder: '', cssclass: 'editable', onblur: 'ignore' };
					var config2 = Object.copy(config1, { _prototype: { type: 'textarea', onblur: 'submit' } });
					$('.edit > a, .edit_area > a, b.edit').addClass('activated');
					$('.edit > a, b.edit').editable('_/save.cgi', config1);
					$('.edit_area > a').editable('_/save.cgi', config2);
				};
				function table_width() {
					var left_size = $(window).width() * Math.PHI;
					var right_size = $(window).width() - left_size - 60;
					self._.dom.table.outer.$_th_first_child.width(left_size)
					self._.dom.div.building_carousels.width(right_size);
					self._.dom.table.inner.width(left_size);
					return true;
				};
				function content_height() {
					var browser_adjustment = 1;
					self._.dom.div.content.height(
						$(window).height() - self._.dom.div.header.height() - browser_adjustment
					);
					return true;
				};
			},
			live_binds: function() { // "live" binds: event handling for dynamically added elements
				var self = this;
				self._.dom.a.admin_ctrl_add_building_picture.mousedown(submit_picture_upload);
				self._.dom.a.admin_ctrl_delete_building_picture.mousedown(handle_picture_delete);
				self._.dom.a.admin_ctrl_add_unit_picture.live('mousedown', submit_picture_upload);
				self._.dom.a.admin_ctrl_delete_unit_picture.live('mousedown', handle_picture_delete);
				var handle_more_toggle_units_initialized = {};
				self._.dom.a.trigger_more.live('mousedown', handle_more_toggle);
				return;
				function submit_picture_upload() {
					$(this).siblings('form').submit();
				};
				function handle_picture_delete() {
					var target = $(this).parent().parent();
					var parent_li = target.parent();
					var picture_id = parseInt(target.attr('id').split('picture_id_')[1]);
					var entity = target.attr('entity');
					$.post('_/delete_picture.cgi', {
						picture_id: picture_id,
						entity: entity
					}, function(r,s) {
						alert('picture deleted. you will not see it deleted until you reload. i will take away this message in due time when you get the point.');
					});
				};
				function handle_more_toggle() {
					var unit_id = parseInt($(this).attr('unit_id'));
					$('#unit_'+ unit_id +'_more').toggle();
					if (!handle_more_toggle_units_initialized[unit_id]) {
						handle_more_toggle_units_initialized[unit_id] = true;
						$('#unit_'+ unit_id + '_more').find('.unit.carousel.active').jMyCarousel({ vertical: true, visible: '2', speed: 150, eltByElt: false, evtStart: 'mouseover', evtStop: 'mouseout' });
					} else {
					}
				};
			}
		}
	},
	show_picture: function(id) {
		$('#picture-modal').removeAttr('class').find('div.content').empty().append('<img src="/picture/'+ id +'"/>');
	},
	show_map: function(name, ll) {
		var coords = ll.split(',');
		var content = $('#map-modal').removeAttr('class').find('div.content');
		if (!baraka.map_initialized) {
			baraka.map_initialized = true;
			content.jmap('init', {
				mapType: 'map',
				mapCenter: coords,
				mapZoom: 16,
				mapControl: 'large',
				mapEnableType: false,
				mapEnableOverview: false,
				mapEnableDragging: true,
				mapEnableInfoWindows: false,
				mapEnableGoogleBar: false,
				mapEnableScaleControl: false,
				mapShowjMapsIcon: false
			});
		}
		content.jmap('AddMarker', {
			mapType: 'map',
			mapCenter: coords,
			mapZoom: 16,
			pointLatLng: coords,
			pointHTML: '<strong>'+ name +'</strong>'
		});
		content.jmap('CheckResize');
	}
};
$(document).ready(function() {
	window.baraka = new Baraka; // instance
});
/*
 * $('#iframe').bind('load', function(){var doc = $($('#iframe').get(0).contentWindow.document); var json = doc.text())})
admin functions
-add building picture
-delete building picture
-add unit picture
-delete unit picture
-add unit
-delete unit
user functions
-...
									<!--
									<img src=""/>
									<form action="_/upload.cgi" method="post" enctype="multipart/form-data">
										<input type="hidden" name="entity" value="building" />
										<input type="hidden" name="entity_id" value="<%= building_id %>" />
										<p><input type="file" name="file" /><input type="submit" value="New Picture" /></p>
									</form> 
									-->
*/
