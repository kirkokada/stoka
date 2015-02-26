$(document).ready(function() {

	var map;
	var marker;

	function initialize () { 
		var mapOptions = {
			zoom: 12,
			center: new google.maps.LatLng(21.3000, -157.8167),
			mapTypeId: google.maps.MapTypeId.ROADMAP
		}
		map = new google.maps.Map(document.getElementById("map-canvas"), mapOptions);

		var markerOptions = {
			position: new google.maps.LatLng(21.3000, -157.8167),
			title: "Hello!",
			map: map
		}

		marker = new google.maps.Marker(markerOptions)
	};


	google.maps.event.addDomListener(window, 'load', initialize);

});