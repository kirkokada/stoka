var map;
var marker;
var markers = [];
var bounds

$(document).ready(function() {
	 bounds = new google.maps.LatLngBounds();


	function initialize () { 
		var mapOptions = {
			zoom: 12,
			center: new google.maps.LatLng(21.3000, -157.8167),
			mapTypeId: google.maps.MapTypeId.ROADMAP
		}
		map = new google.maps.Map(document.getElementById("map-canvas"), mapOptions);
	};

	google.maps.event.addDomListener(window, 'load', initialize);

});

// Create a marker and infowindow at the coordinates and push the to an array

function createMarker (lat, lng, content) {
	var position = new google.maps.LatLng(lat, lng);
	marker = new google.maps.Marker({
		position: position,
		map: map
	});
	var infowindow = new google.maps.InfoWindow({
		content: content,
		position: position
	});
	google.maps.event.addListener(marker, 'click', function() {
		infowindow.open(map);
	});
	bounds.extend(position);
	map.fitBounds(bounds);
	markers.push(marker)
}

// Sets the map on all the markers in the array

function setAllMap (map) {
	for (var i = 0; i < markers.length; i++) {
		markers[i].setMap(map);
	}
}

// Clear all markers

function clearMarkers () {
	setAllMap(null);
}

function deleteMarkers () {
	setAllMap(null);
	markers = [];
}