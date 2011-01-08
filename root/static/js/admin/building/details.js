/*
$(function() {
	$('#full_address').change(function() {
		var val = $(this).val();
		if (!val.match(/Urbana/) && !val.match(/Champaign/)) {
			val += ' Champaign IL';
		}
		geocoder.geocode({ address: val }, function(result, status) {
			if (status == google.maps.GeocoderStatus.OK) {
				var full_address = result[0].formatted_address;
				var latitude_longitude = result[0].geometry.location.lat() +','+ result[0].geometry.location.lng();
				$('#full_address').val(full_address);
				$('#latitude_longitude').val(latitude_longitude);
				coordinates = result[0].geometry.location;
				map.setCenter(coordinates);
				marker.setPosition(coordinates);
			}
		});
	});
});
*/
