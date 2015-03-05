# STOKA

Stoka is an add on to Instagram that adds context to photos using Google Maps' street view.

See it in action [here](https://arcane-sierra-2324.herokuapp.com/).

# Use / Flow

Simply input an Instagram username into the box and hit the search button. Stoka then will query Instagram to find the first matching username and fetch their recent media (if location data is available).

Alternatively, signing in with Instagram displays your followed users list and clicking on a user will display their media on the map (if location data is available).

If the user exists and their media has location data, Stoka will query the Google Maps database and drop markers at the locations where the media was recorded/uploaded on the map. Clicking on the markers takes you to a street view panorama if one exists within a 50 meter radius of the marker coordinates. 

# Current Features

* Devise backed user authentication/authorization

* Omniauth-instagram for Instagram authentication

* AJAX user interface

* Google Maps and Instagram API integration 

* Bootstrap 3 CSS framework

* RSpec / Capybara test suite

# Future Features

* Twitter/Facebook integration

* Web scraping based on names/keywords

# Testing

This app uses the VCR gem to mock responses. As the response data contains a lot of personal information (api keys, followed user lists, etc.) from actual social media accounts, the vcr cassettes have not been added to version control. Please use your own credentials if you fork this project 