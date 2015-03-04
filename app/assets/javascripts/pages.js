var map;
var marker;
var markers = [];
var bounds;
var panorama;
var sv

$(document).ready(function() {
	bounds = new google.maps.LatLngBounds();

	// Map must be initialized *after* Google scripts are loaded

	function initialize () { 
		var default_center = new google.maps.LatLng(21.3000, -157.8167) // Replace later with location from client ip
		var mapOptions = {
			zoom: 12,
			center: default_center,
			mapTypeId: google.maps.MapTypeId.ROADMAP
		}
		map = new google.maps.Map(document.getElementById("map-canvas"), mapOptions);
		panorama = map.getStreetView();
		panorama.setPosition(default_center);
		panorama.setPov(({
			heading: 265,
			pitch: 0
		}));
		sv = new google.maps.StreetViewService();
	};
	google.maps.event.addDomListener(window, 'load', initialize);
});

// Creates a marker and infowindow at the coordinates and push the markers to an array,
// then adjusts the bounds of the map to fit all markers in the array.

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

	// Add a listener for clicks to the marker to Get and display a nearby panorama location,  
	// then open an info window on that panorama. Displays the info window on the road map 
	// if a nearby panorama is unavailable.

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

				panorama.setVisible(true);

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

// Hide the street view panorama

function hideStreetView () {
	panorama.setVisible(false);
}

// Display flash notice modal 

function showFlashModal () {
	$("#flash-modal").modal("show");
}
