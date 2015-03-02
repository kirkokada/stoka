var map;
var marker;
var markers = [];
var bounds;
var panorama;
var sv

$(document).ready(function() {
	 bounds = new google.maps.LatLngBounds();


	function initialize () { 
		var mapOptions = {
			zoom: 12,
			center: new google.maps.LatLng(21.3000, -157.8167),
			mapTypeId: google.maps.MapTypeId.ROADMAP
		}
		map = new google.maps.Map(document.getElementById("map-canvas"), mapOptions);
		panorama = map.getStreetView();
		panorama.setPosition(new google.maps.LatLng(21.3000, -157.8167));
		panorama.setPov(({
			heading: 265,
			pitch: 0
		}));
		sv = new google.maps.StreetViewService();
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

	// Get and display a nearby panorama location, then open the info window on that panorama
	// after clicking on a marker. Displays the info window on the road map if panorama unavailable.

	google.maps.event.addListener(marker, 'click', function() {
		sv.getPanoramaByLocation(position, 50, function(result, status) {
			if (status == google.maps.StreetViewStatus.OK) {

				// Set panorama heading to point in the direction of the marker

				var heading = google.maps.geometry.spherical.computeHeading(result.location.latLng, position);
				panorama.setPosition(result.location.latLng);
				panorama.setPov(({
					heading: heading,
					pitch: 0
				}));

				// Display panorama

				panorama.setVisible(true);

				// Open the info window on the panorama

				infowindow.open(panorama);
			} else {
				alert("No street view is available within 50m.");
				infowindow.open(map)
			}
		});
	});

	bounds.extend(position);
	map.fitBounds(bounds);
	markers.push(marker);
}

// Sets the map on all the markers in the array

function setAllMap (map) {
	for (var i = 0; i < markers.length; i++) {
		markers[i].setMap(map);
	}
}

// Clear all markers from map but keep them in the array

function clearMarkers () {
	setAllMap(null);
}

// Delete all markers and remove them from the map

function deleteMarkers () {
	setAllMap(null);
	markers = [];
}