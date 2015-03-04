# STOKA

Stoka is an add on to Instagram that adds context to photos using Google Maps' street view.

See it in action [here](https://arcane-sierra-2324.herokuapp.com/).

# Use / Flow

Simply input an Instagram username into the box and hit the "Stoka!" button.

Stoka then will query Instagram to find the matching username and fetch their recent media.

If the user exists and if their recent media contains location data, Stoka will query the Google Maps database and drop markers at the locations where the media was recorded/uploaded on the map. Clicking on the markers takes you to a street view panorama (if available).

# Current Features

* Devise backed user authentication/authorization

* Omniauth-instagram for Instagram authentication

* AJAX user interface

* Google Maps and Instagram API integration 

* Bootstrap 3 CSS framework

# Future Features

* Twitter/Facebook integration

* 